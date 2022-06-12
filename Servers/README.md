# Progress
- Link cloned a Domain Controller
- Changed hostname to DC1
    - sconfig option 2
- Set static IP 172.16.185.10
    - sconfig option 8
    - option 1
    - option 1
    - default gateway 172.16.185.2
- Preferred DNS set to 172.16.185.10
    - sconfig option 8
    - option 2
- Install ADDS
    - Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools


