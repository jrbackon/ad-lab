# Progress
- Created a linked clone of base workstation template
- Updated Primary DNS to point to DC1
- Changed computer name to Workstation01
'''
Rename-Computer -NewName "Workstation01"
'''
- Add computer to domain reezun.home
'''
Add-Computer -domainname reezun.home -Restart
'''
- Note: this didn't work. Had to use the gui.