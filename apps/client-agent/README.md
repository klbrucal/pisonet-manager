# Windows Agent

Background C# agent installed on each managed Windows PC. Configuration is embedded into the executable during publishing.

Build release-ready agent executables from the repo root with:

```powershell
.\build-release.ps1
```

The release outputs are written to the project folder.

To publish only the default `Test` agent directly:

```powershell
dotnet publish PisonetManager.Agent -c Release -o ..\..\..\.build-temp\client-agent\Test
```

The default build embeds `Location: Test`. Publish both location-specific agents with:

```powershell
dotnet publish PisonetManager.Agent -c Release -o ..\..\..\.build-temp\client-agent\Test -p:AgentLocation=Test
dotnet publish PisonetManager.Agent -c Release -o ..\..\..\.build-temp\client-agent\Aprang -p:AgentLocation=Aprang
```
