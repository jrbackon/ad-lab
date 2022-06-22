# Progress
- Built workstation template
- Installed Updates
- Shutdown and took snapshots

- Creating ad.schema.json
- Convert .json to powershell objects

```
Get-Content .\ad.shema.json | ConvertFrom-Json
```

- Send .json file to DC1
    - Open a PSSession and save output to a variable like $dc

    ```
     Copy-Item .\ad.schema.json -ToSession $dc C:\Windows\Tasks
    ```
- To run powershell scripts:

```
Set-ExecutionPolicy RemoteSigned
```

- Created script to generate AD users and groups from a .json configuration file.

- Created script to generate a .json file with a quasi-random set of users and groups. This can beused to generate a quasi-random AD environment with the gen_ad.ps1 script.

- Created DC snapshot after workstation was added to domain to fix domain join break after resetting the DC.

- Added ability to weaken or strengthen the password policy to facilitate bulk adding users.

- Added code to remove users and groups based on the same .json schema used to add them. Random users and groups can easily be added and removed now.

# GIT Setup Notes
- Git add
- Git commit
- Git push
    - username
    - personal token. Expires on July 12.
    - https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

# PS Remoting
- Need to add the remote server to the trusted hosts list.
- Start the winrm service on the local machine (as administrator):

```
Start-Service WinRM
```

- Add the remote server to the trusted hosts list:

``` 
Set-Item WSMan:\localhost\Client\TrustedHosts -value 172.16.185.10
```

- Start the remote PSSession:

```
New-PSSession -ComputerName 172.16.185.10 -Credential (Get-Credential)
```

- Enter the remote session (1 is the session ID):

```
Enter-PSSession 1
```

# MGMT Workstation
- Dev environment setup
    - VSCode installed
    - Git installed
    - Repo cloned to local machine