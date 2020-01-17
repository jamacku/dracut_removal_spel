Name:           dracut-removal-spell           
Version:        0.1.3
Release:        1%{?dist}
Summary:        TEST PACKAGE to build initrd without dracut       

License:        GPLv3     
URL:            https://github.com/jamacku/%{name}/tree/master
Source0:        https://github.com/jamacku/%{name}/archive/%{version}/%{name}-%{version}.tar.gz

Requires:       dnf
Requires:       bash
Requires:       systemd
Requires:       grubby
Requires:       cpio
Requires:       gzip

%description
TEST PACKAGE to build initrd without dracut       

%prep
%autosetup

%build

%install
mkdir -p %{buildroot}/%{_sysconfdir}/kernel/postinst.d/
cp -a etc/initrd.conf %{buildroot}/%{_sysconfdir}/initrd.conf
cp -a etc/kernel/postinst.d/%{name}.sh %{buildroot}/%{_sysconfdir}/kernel/postinst.d/%{name}.sh

%files
%license COPYING
%doc README.md
%{_sysconfdir}/initrd.conf
%{_sysconfdir}/kernel/postinst.d/%{name}.sh


%changelog
* Fri Jan 17 2020 Jan Macku <jamacku@redhat.com> - 0.1.3-1
- Initial package 
