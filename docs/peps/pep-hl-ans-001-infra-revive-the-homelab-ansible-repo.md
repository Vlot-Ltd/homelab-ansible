# PEP-HL-ANS-001: Revive the homelab Ansible repo

**ID:** PEP-HL-ANS-001  
**Title:** Revive the homelab Ansible repo  
**Author:** Timo Vlot  
**Status:** Draft  
**Type:** Infrastructure  
**Priority:** Medium  
**Created:** 2026-10-10  
**Updated:** 2026-10-10  
**Supersedes:** N/A  
**Superseded-By:** N/A  

## Abstract

Revive the homelab Ansible repo so Ansible is a working tool in the homelab: a controller, a real inventory, linting, and a first useful playbook. Part of the vault project `homelab-ansible-and-awx`.

## Motivation

The repo stopped on 2024-06-02 after the initial skeleton: `project/ansible.cfg`, an inventory with `ansible.local` and `plex.local` (`.local` names that don't match the Salt hostnames), and `ansiblesetup.sh`, which builds `production/staging/development` inventories while `ansible.cfg` points at `inventories/homelab/`. No playbooks or roles exist.

Salt already manages configuration. Ansible's job needs defining so the two don't overlap.

## Specification

### Requirements

- A clear boundary with Salt, written in the README (to decide; candidates: agentless jobs on hosts without a minion such as the Proxmox host, appliances and network kit; one-off orchestration; learning)
- `ansible-core` pinned, installed with `uv` (or pipx) on a named controller; collections pinned in `requirements.yml`
- Inventory from one source of truth: Tailscale/MagicDNS names now, NetBox dynamic inventory later (`netbox.netbox.nb_inventory`)
- Logs in as the PEP-HL-SLT-018 automation account, never `proxmox`; secrets from Vault (`community.hashi_vault`)
- `ansible-lint` in pre-commit
- Layout AWX can use as a project (PEP-HL-ANS-002)

### Implementation Approach

1. Decide the Salt/Ansible boundary
2. Clean up the skeleton: one inventory layout, drop `ansiblesetup.sh` or fix it
3. Controller and pinned versions
4. One read-only playbook (e.g. gather facts or check disk space on every host) as the first test

### Success Criteria

- `ansible-inventory --graph` shows the real hosts
- `ansible all -m ping` succeeds as the automation account
- The first playbook runs clean and `ansible-lint` passes

## Implementation Plan

### Phase 1: boundary and cleanup

### Phase 2: controller, inventory, first playbook

### Phase 3: NetBox inventory (after NetBox is usable)

## Testing Strategy

`--check --diff` on every playbook first; `ansible-lint` in pre-commit.

## Documentation Requirements

README: what Ansible is for here (vs Salt), how to run it, where secrets come from.

## Risks and Mitigation

- Salt and Ansible both managing the same thing: the boundary rule; Ansible never touches what a Salt state manages.

**Backout:** the repo only; nothing on hosts changes until a playbook runs, and the first one is read-only.

## References

- PEP-HL-ANS-002 (AWX)
- PEP-HL-SLT-018 (homelab-saltstack): automation account
- Vault: `30-projects/homelab-ansible-and-awx.md`

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2026-10-10 | Timo Vlot | Initial draft |
