class SguiFacade

  def initialize
  end

  ####

  def login(user, password)
    user == "admin" && password == "admin"
  end

  ####

  def can_access_group(user, group)
    true
  end

  ####

  def list_groups
    %w(csi cri sgaf)
  end

  def list_group_members(group)
    %w(fulano sicrano beltrano)
  end

  def update_group(group, members)
  end


end