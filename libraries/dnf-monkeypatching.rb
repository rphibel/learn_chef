
class Chef
  class Provider
    class Package
      class Dnf < Chef::Provider::Package
        def install_package(names, versions)
          rpmcow_denylist = [
            "vim",
          ]
          if new_resource.source
            puts "\nDEBUGRP new_resource.package_name: #{new_resource.package_name} #{rpmcow_denylist.include?(new_resource.package_name)}"
            if rpmcow_denylist.include?(new_resource.package_name)
              dnf(options, "-y", "--disableplugin=dnf-plugin-cow", "install", new_resource.source)
            else
              dnf(options, "-y", "install", new_resource.source)
            end
          else
            resolved_names = names.each_with_index.map { |name, i| available_version(i).to_s unless name.nil? }
            puts "\nDEBUGRP new_resource.package_name: #{new_resource.package_name} #{rpmcow_denylist.include?(new_resource.package_name)}"
            resolved_names_in_denylist, resolved_names_not_in_denylist = resolved_names.partition.with_index { |name, i| rpmcow_denylist.include?(package_name_array[i])}
            puts "\nDEBUGRP resolved_names: #{resolved_names}"
            puts "\nDEBUGRP resolved_names_in_denylist: #{resolved_names_in_denylist} empty: #{resolved_names_in_denylist.empty?}"
            puts "\nDEBUGRP resolved_names_not_in_denylist: #{resolved_names_not_in_denylist} empty: #{resolved_names_not_in_denylist.empty?}"
            if !resolved_names_in_denylist.empty?
              dnf(options, "-y", "--disableplugin=dnf-plugin-cow", "install", resolved_names_in_denylist)
            end
            if !resolved_names_not_in_denylist.empty?
              dnf(options, "-y", "install", resolved_names_not_in_denylist)
            end
          end
          flushcache
        end

      end
    end
  end
end
