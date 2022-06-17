# Progress
- Built workstation template
- Installed Updates
- Shutdown and took snapshots

- Attempted New-PSSession from MGMT workstation. 

    ```
    New-PSSession -ComputerName 172.16.185.10 -Credential (Get-Credential)
    ```

    - Need to research winrm trusted hosts to get this to work.
    - Tried this command on DC1.
    
    ```
    Enable-PSRemoting
    ```

- Creating ad.schema.json
- Convert .json to powershell objects

```
Get-Content .\ad.shema.json | ConvertFrom-Json
```

# GIT Setup Notes
- Git add
- Git commit
- Git push
    - username
    - personal token. Expires on July 12.
    - https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

# MGMT Workstation
- Dev environment setup
    - VSCode installed
    - Git installed
    - Repo cloned to local machine