# Autoconverted recipe from recipes/vim.yml

apt_update "" do
end

package "Install vim" do
  package_name ["vim", "dos2unix"]
end
