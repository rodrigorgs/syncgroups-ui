require 'net/ldap'
require 'yaml'

class SguiFacade

  def initialize(yaml_filename)
    config = YAML.load_file(yaml_filename)['ldap']
    @ldap = Net::LDAP.new
    @ldap.host = config['host']
    @ldap.port = config['port']
    @ldap.base = config['basedn']
    @ldap.auth config['binddn'], config['password']
    @ldap.bind or raise RuntimeError, 'Could not connect to LDAP server.'
  end

  ####

  def login(user, password)
    password == "123"
  end

  ####

  def can_access_group(user, group)
    true
    # list_groups_managed_by_user(user).include?(group)
  end

  ####

  def list_groups_managed_by_user(user)
    # TODO: should look for "-admin" groups
    groups = []
    filter = Net::LDAP::Filter.eq("cn", user)
    results = @ldap.search(filter: filter, attributes: ['memberOf'])
    if results && results.size == 1
      ldapuser = results[0]
      groups = ldapuser.memberOf.map { |dn| $1 if dn =~ /^.*?=(.*?),/ }
    end
    groups
  end

  def list_groups
    groups = []
    filter = Net::LDAP::Filter.eq("objectclass", "group")
    results = @ldap.search(filter: filter, attributes: ['dn'])
    if results && results.size > 0
      groups = results.map { |obj| $1 if obj.dn =~ /^.*?=(.*?),/ }
    end
    groups
  end

  def list_group_members(group)
    members = []

    filter = Net::LDAP::Filter.eq("CN", group)
    results = @ldap.search(filter: filter, attributes: ['member'])
    if results.size == 1
      ldapgroup = results[0]
      members = ldapgroup.member.map { |dn| $1 if dn =~ /^.*?=(.*?),/ }
    end

    members
  end

  def update_group(group, members)
  end

end

