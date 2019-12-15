defmodule Collabiq.Seed do
  def start() do
    session = %{
      admin_perms: %{
        create_admin_role: true,
        create_agent: true,
        create_directory: true,
        create_site: true,
        create_work_role: true
      }
    }

    {:ok, tenant} = Collabiq.Tenant.create(%{name: "Test Tenant"})
    session = Map.put(session, :t_id, tenant.id)
    {:ok, abc} = create_site(%{name: "ABC"}, session)
    {:ok, jkl} = create_site(%{name: "JKL"}, session)
    {:ok, xyz} = create_site(%{name: "XYZ"}, session)

    {:ok, work_role} =
      create_work_role(
        %{
          name: "Help Desk",
          sites_work_roles: [
            %{
              site_id: abc.id,
              perms: %{
                create_user: true
              }
            },
            %{
              site_id: jkl.id,
              perms: %{
                create_user: true,
                manage_user: true,
                purge_user: true
              }
            }
          ]
        },
        session
      )

    {:ok, admin_role} =
      create_admin_role(
        %{
          name: "System Administrator",
          perms: %{
            create_admin_role: true,
            create_directory: true,
            manage_directory: true,
            purge_directory: true,
            create_site: true,
            manage_site: true,
            purge_site: true
          }
        },
        session
      )

    {:ok, agent} =
      create_agent(
        %{
          admin_role_id: admin_role.id,
          name: "Administrator",
          email: "admin@email.com",
          password: "password",
          work_role_id: work_role.id
        },
        session
      )

    {:ok, abc_directory} =
      create_directory(
        %{name: "ABC AD", server: "127.0.0.1", un: "administrator", site_id: abc.id},
        session
      )

    {:ok, jkl_directory} =
      create_directory(
        %{name: "JKL AD", server: "127.0.0.1", un: "administrator", site_id: jkl.id},
        session
      )

    {:ok, xyz_directory} =
      create_directory(
        %{name: "XYZ AD", server: "127.0.0.1", un: "administrator", site_id: xyz.id},
        session
      )
  end

  def create_admin_role(attrs, sess) do
    Collabiq.create_admin_role(attrs, sess)
  end

  def create_agent(attrs, sess) do
    Collabiq.create_agent(attrs, sess)
  end

  def create_directory(attrs, sess) do
    Collabiq.create_directory(attrs, sess)
  end

  def create_site(attrs, sess) do
    Collabiq.create_site(attrs, sess)
  end

  def create_work_role(attrs, sess) do
    Collabiq.create_work_role(attrs, sess)
  end
end
