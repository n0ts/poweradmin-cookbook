name             'poweradmin'
maintainer       'Naoya Nakazawa'
maintainer_email 'me@n0ts.org'
license          'All rights reserved'
description      'Installs/Configures poweradmin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ apache2 htpasswd php-wrapper }.each do |depend|
  depends depend
end
