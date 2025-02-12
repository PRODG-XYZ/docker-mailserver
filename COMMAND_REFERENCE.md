# Comprehensive Command Reference

This document provides a quick reference for the various commands used in this repository. It covers Docker Mailserver account and alias management, Tailscale networking commands, and NGINX container maintenance.

---

## 1. Docker Mailserver Commands

These commands are executed inside the Docker Mailserver container to manage accounts and aliases via the built‑in `setup` CLI.

| Command Syntax                                    | Description                                                                       | Example                                                       |
| ------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `setup help`                                      | Displays help information and a list of available subcommands.                    | `docker exec -ti mailserver setup help`                       |
| `setup email add <email> <password>`              | Adds a new email account with the specified email address and password.           | `docker exec -ti mailserver setup email add user@domain.tld mypass` |
| `setup email del <email>`                         | Deletes an existing email account (removes associated aliases and quota).         | `docker exec -ti mailserver setup email del user@domain.tld`    |
| `setup email list`                                | Lists all configured email accounts.                                              | `docker exec -ti mailserver setup email list`                 |
| `setup email passwd <email> <new-password>`       | Changes the password for the specified email account.                             | `docker exec -ti mailserver setup email passwd user@domain.tld newpass` |
| `setup alias add <alias> <destination>`           | Creates an alias so mail sent to the alias forwards to the target account.        | `docker exec -ti mailserver setup alias add alias@domain.tld user@domain.tld` |
| `setup alias del <alias>`                         | Removes an existing alias.                                                        | `docker exec -ti mailserver setup alias del alias@domain.tld`   |
| `setup alias list`                                | Lists all configured email aliases.                                               | `docker exec -ti mailserver setup alias list`                 |

### Usage Notes

- **Execution Context:** Run these commands inside the Docker Mailserver container (replace `mailserver` with your container name if needed).
- **Initial Account Requirement:** On first start, you must add at least one email account; otherwise, the container may restart.
- **Automation:** These CLI commands can be scripted for bulk account provisioning.

For more advanced configuration (e.g., LDAP integrations, DKIM, and DMARC), please refer to the [Docker Mailserver documentation](https://docker-mailserver.github.io/docker-mailserver/).

---

## 2. Tailscale Commands

These commands help manage the Tailscale client and control the Funnel feature used to expose services.

| Command Syntax                                     | Description                                                                       | Example                                                       |
| -------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `sudo tailscale up`                                | Brings up the Tailscale client using configured options (auth key, etc.).         | `sudo tailscale up`                                           |
| `tailscale status`                                 | Displays the current Tailscale network status and connected nodes.                | `tailscale status`                                            |
| `tailscale ip -4`                                  | Shows the Tailscale-assigned IPv4 addresses for the node.                         | `tailscale ip -4`                                             |
| `tailscale ping <node>`                            | Pings another node within your Tailscale network.                                 | `tailscale ping mail.prodg.xyz`                               |
| `sudo tailscale funnel enable <PORT>`              | Enables Tailscale Funnel on the specified port, exposing the service to the public. | `sudo tailscale funnel enable 443`                            |
| `sudo tailscale funnel disable <PORT>`             | Disables the Funnel exposure on the specified port.                               | `sudo tailscale funnel disable 443`                           |

### Usage Notes

- Tailscale commands are typically run on the Docker host.
- Ensure your environment has the appropriate authentication key (TS_AUTHKEY) configured.
- Use the Funnel commands to expose services (e.g., NGINX listening on port 443) securely over Tailscale.

---

## 3. NGINX Commands

These commands are useful for testing and reloading the NGINX configuration, which is acting as a stream proxy to route mail services.

| Command Syntax                                         | Description                                                                       | Example                                                       |
| ------------------------------------------------------ | --------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `docker exec -it nginx-stream nginx -t`                | Tests the current NGINX configuration for syntax correctness.                     | `docker exec -it nginx-stream nginx -t`                       |
| `docker exec -it nginx-stream nginx -s reload`         | Reloads the NGINX configuration without requiring a full container restart.       | `docker exec -it nginx-stream nginx -s reload`                |
| `docker logs nginx-stream`                             | Displays the logs from the NGINX container for debugging purposes.                | `docker logs nginx-stream`                                    |
| `docker exec -it nginx-stream bash`                    | Opens an interactive shell inside the NGINX container for manual inspection.      | `docker exec -it nginx-stream bash`                           |

### Usage Notes

- These commands assume the NGINX container is named `nginx-stream`.
- Regularly test (`nginx -t`) after making changes to `nginx-stream.conf` to avoid misconfiguration.
- Reloading NGINX allows you to apply configuration changes without downtime.

---

This comprehensive reference should serve as a quick guide to managing your Docker Mailserver instance, Tailscale networking, and NGINX reverse proxy functionalities.