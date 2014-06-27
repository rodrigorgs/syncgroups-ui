require 'net/ldap'
require 'yaml'

class SguiFacade

  def initialize(yaml_filename)
    @config = YAML.load_file(yaml_filename)['ldap']
    @ldap = Net::LDAP.new
    @ldap.host = @config['host']
    @ldap.port = @config['port']
    @ldap.base = @config['basedn']
    @ldap.auth @config['binddn'], @config['password']
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

  def autocomplete_name(prefix)
    return [] if prefix.length < 3

    names = []
    filter = Net::LDAP::Filter.eq(@config['fullname_attr'], "#{prefix}*")
    results = @ldap.search(filter: filter, attributes: [@config['fullname_attr']])
    p results
    if results && results.size > 0
      names = results.map { |obj| obj[@config['fullname_attr']][0] }
    end
    names
  end

  def dn_from_user(user)
    filter = filter = Net::LDAP::Filter.eq(@config['user_rdn'], user)
    results = @ldap.search(filter: filter, attributes: [@config['user_rdn']])

    results.size == 1 ? results[0].dn : nil
  end

  def list_groups_managed_by_user(user)
    # TODO: should look for "-admin" groups
    userdn = dn_from_user(user)
    return [] if userdn.nil?

    filter_objclass = Net::LDAP::Filter.eq("objectclass", @config['group_objectclass'])
    filter_user = Net::LDAP::Filter.eq(@config['group_members_attr'], userdn)
    filter = Net::LDAP::Filter.join(filter_objclass, filter_user)
    results = @ldap.search(filter: filter, attributes: [@config['group_rdn']])

    results.map { |obj| obj[@config['group_rdn']][0] }
  end

  def list_groups
    groups = []
    filter = Net::LDAP::Filter.eq("objectclass", @config['group_objectclass'])
    results = @ldap.search(filter: filter, attributes: ['dn'])
    if results && results.size > 0
      groups = results.map { |obj| $1 if obj.dn =~ /^.*?=(.*?),/ }
    end
    groups
  end

  def list_group_members(group)
    members = []

    filter = Net::LDAP::Filter.eq(@config['group_rdn'], group)
    results = @ldap.search(filter: filter, attributes: [@config['group_members_attr']])
    if results.size == 1
      ldapgroup = results[0]
      members = ldapgroup.member.map { |dn| $1 if dn =~ /^.*?=(.*?),/ }
    end

    members
  end

  def dns_from_users(users)
    filters = users.map { |user| Net::LDAP::Filter.eq(@config['user_rdn'], user) }
    filter = Net::LDAP::Filter.construct("(|#{filters.join('')})")
    results = @ldap.search(filter: filter, attributes: ['db', @config['user_rdn']])
    dns = results.map { |obj| obj.dn }
    dns
  end

  def dn_from_group(group)
    filter = filter = Net::LDAP::Filter.eq(@config['group_rdn'], group)
    results = @ldap.search(filter: filter, attributes: [@config['group_rdn']])

    results.size == 1 ? results[0].dn : nil
  end

  def update_group(group, members)
    user_dns = dns_from_users(members)
    group_dn = dn_from_group(group)
    @ldap.replace_attribute(group_dn, @config['group_members_attr'], user_dns)
  end

end

