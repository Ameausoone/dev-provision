# MCP servers

## Atlassian

Add Atlassian MCP server (see https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/)

```shell
claude mcp add --scope user --transport sse atlassian https://mcp.atlassian.com/v1/sse
```

Then don't forget to run `/mcp` => atlassian, and authenticate.

## GitHub

```shell
claude mcp add --scope user --transport http github https://api.githubcopilot.com/mcp -H "Authorization: Bearer $bearer"
```

## Jetbrains

Enable MCP server in IntelliJ Idea (Settings => Tools => MCP Server) then:

```shell
 claude mcp add --scope user --transport sse jetbrains http://localhost:64342/sse
```
