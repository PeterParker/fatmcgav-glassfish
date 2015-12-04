$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","..",".."))
require 'puppet/provider/asadmin'

Puppet::Type.type(:jmsresource).provide(:asadmin, :parent =>
Puppet::Provider::Asadmin) do
  desc "Glassfish JMS resource support."
  def create
    args = Array.new
    args << 'create-jms-resource'
    args << "--target" << @resource[:target] if @resource[:target]
    args << '--restype' << @resource[:restype]
    if hasProperties? @resource[:properties]
      args << '--property'
      args << "\'#{prepareProperties @resource[:properties]}\'"
    end
    args << '--description' << "\'#{@resource[:description]}\'" if @resource[:description] and
    not @resource[:description].empty?
    args << @resource[:name]

    asadmin_exec(args)
  end

  def destroy
    args = Array.new
    args << 'delete-jms-resource'
    args << 'target' << @resource[:target] if @resource[:target]
    args << @resource[:name]

    asadmin_exec(args)
  end

  def exists?
    args = Array.new
    args << "list-jms-resources"
    args << @resource[:target] if @resource[:target]

    asadmin_exec(args).each do |line|
      return true if @resource[:name] == line.chomp
    end
    return false
  end
end
