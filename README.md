# Syncgroups-UI (SGUI)

Syncgroups-UI (SGUI) is a minimal web interface to manage [LDAP](http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol) groups.

Usually sysadmins are responsible for managing groups of users, because they are often the only ones with access and expertise to make changes to LDAP databases. However, sysadmins may not be informed right away when a person should enter or leave a group, so LDAP groups become outdated.

With SGUI, the management of a LDAP group can be delegated to a subset of the members of the group, who are aware of any changes in the their team. In other words, SGUI decentralize group management by empowering users and lowering the technical barriers.

## How it works

SGUI looks for groups in a LDAP server and allows authorized users to add or remove users from these groups. The permission model is very simple: if a group is named "nnn", SGUI looks for a group named "nnn-admin", containing the users allowed to manage group "nnn".

SGUI does not *create* LDAP groups. It is expected that groups are still created by sysadmins using a LDAP client. Once groups are created, however, they can be managed by regular users using SGUI.

SGUI is currently under development, so it may not be usable right now. See the [`TODO.md`](TODO.md) for planned features.

## Running

SGUI is tested with Ruby 2.0.

First, install the dependencies using [Bundler](http://bundler.io/):

    bundle install

Then, create the file `config/sgui.yml` (based on `sgui.yml.example`) with your LDAP configuration.

After that, run the web application:

    ruby sguiserver.rb

Finally, open the web interface at <http://localhost:4567/>.

## Development mode

If you wish to contribute to SGUI or test the application and you don't have a LDAP server available, you can run SGUI in *development mode*. In this mode, the LDAP server is replaced by a local database. In this case, run:

    ruby sguiserver.rb development

While developing, it may be useful to run the web application with [rerun](https://github.com/alexch/rerun), so it is restarted whenever a file is changed:

    rerun sguiserver.rb development

(Make sure to install rerun first with `gem install rerun`.)