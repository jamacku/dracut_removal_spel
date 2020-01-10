Name:           dracut-removal-spell           
Version:        0.1
Release:        1%{?dist}
Summary:        TEST PACKAGE to build initrd without dracut       

License:        GPLv3     
URL:            https://github.com/jamacku/dracut-removal-spell/tree/master
Source0:        https://github.com/jamacku/%{name}/archive/%{version}/%{name}-%{version}.tar.gz

Requires:       systemctl
Requires:       grubby

%description
TEST PACKAGE to build initrd without dracut       


%prep
%autosetup


%build
%configure
%make_build


%install
%make_install


%files
%license COPYING
%doc README.md
%{_sysconfdir}/initrd.conf
%{_sysconfdir}/kernel/postinst.d/dracut-removal-spell.sh



%changelog
* Tue Jan  7 2020 Jan Macku <jamacku@redhat.com>
- Initial package 
