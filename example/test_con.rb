require 'oci8'
cn=OCI8.new('SYSTEM','oracle', '//172.20.0.4/XE')
cn.exec('select * from users') do |r|
  puts r.join(',')
end
