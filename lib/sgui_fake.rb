# encoding: utf-8

require 'pstore'
require 'fileutils'

class SguiFakeFacade

  def initialize(yaml_filename)
    FileUtils.mkdir 'db' unless Dir.exist?('db')
    if !File.exist?('db/dev.pstore')
      @db = PStore.new('db/dev.pstore')
      @db.transaction do
        @db[:users] = %w(fulano-silva beltrano-santos sicrano-joão
            josé-alves maria-josé ana-maria maria-paula ana-silva)
        # @db[:users] = ['Fulano Silva', 'Beltrano Santos', 'Sicrano João',
            # 'José Alves', 'Maria José', 'Ana Maria', 'Maria Paula', 'Ana Silva']
        @db[:groups] = %w(devs ops hr devs-admin ops-admin hr-admin)
        @db[:assignment] = {
          'devs' => %w(fulano-silva beltrano-santos sicrano-joão),
          'devs-admin' => %w(fulano-silva),
          'ops' => %w(fulano-silva josé-alves maria-josé),
          'ops-admin' => %w(fulano-silva),
          'hr' => %w(ana-maria maria-paula ana-silva),
          'hr-admin' => %w(maria-paula)}
        @db.commit
      end
    else
      @db = PStore.new('db/dev.pstore')
    end
  end

  ####

  def login(user, password)
    password == "123"
  end

  ####

  def can_access_group(user, group)
    true
  end

  ####

  def autocomplete_name(prefix)
    return [] if prefix.length < 3

    @db.transaction do
      users = @db[:users].map { |u| { username: u, fullname: u.gsub('-', ' ').capitalize } }
      users.select { |user| user[:username].include?(prefix) || user[:fullname].include?(prefix) }
    end
  end

  def list_groups_managed_by_user(user)
    @db.transaction do
      @db[:groups]
    end
  end

  def list_groups
    @db.transaction do
      @db[:groups]
    end
  end

  def list_group_members(group)
    @db.transaction do
      @db[:assignment][group]
    end
  end

  def update_group(group, members)
    @db.transaction do
      @db[:assignment][group] = members
      @db.commit
    end
  end

  def add_member(group, member)
   @db.transaction do
      @db[:assignment][group] << member
      @db.commit
    end
  end

end

