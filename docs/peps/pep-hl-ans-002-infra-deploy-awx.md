# PEP-HL-ANS-002: Deploy AWX (open-source Ansible Tower)

**ID:** PEP-HL-ANS-002  
**Title:** Deploy AWX (open-source Ansible Tower)  
**Author:** Timo Vlot  
**Status:** Draft  
**Type:** Infrastructure  
**Priority:** Medium  
**Created:** 2026-10-10  
**Updated:** 2026-10-10  
**Supersedes:** N/A  
**Superseded-By:** N/A  

## Abstract

Deploy AWX, the open-source upstream of Ansible Tower / Automation Platform, so Ansible jobs run from a web UI and API with credentials, schedules and logs in one place. Part of the vault project `homelab-ansible-and-awx`.

## Motivation

A central place to run playbooks, with an audit trail and an API, is also a candidate door for JARVIS (see vault `jarvis-access-model`, which prefers one audited path).

**AWX needs Kubernetes.** Since AWX 18 the only supported install is the AWX Operator on a Kubernetes cluster; there is no supported Docker or VM install. That makes Kubernetes a prerequisite of this PEP.

## Specification

### Requirements

- A Kubernetes target. Options to decide:
  - single-node k3s VM just for AWX, built by OpenTofu (PEP-HL-TOFU-002) and configured by Salt
  - the Talos cluster from the vault draft `talos-kubernetes-cluster-rebuild`
- AWX Operator and AWX pinned to specific versions
- Postgres: the operator's bundled instance, or a database on the existing `postgres` VM
- HTTPS on a Tailscale name (`awx.taile3eee.ts.net`), per the homelab Tailscale HTTPS project
- Credentials in AWX sourced from Vault (HashiCorp Vault credential plugin), not typed in
- Project: the `homelab-ansible` repo; inventory: the same source as PEP-HL-ANS-001
- Backups of the AWX database

### Implementation Approach

1. Decide the Kubernetes target; build it
2. Install the AWX Operator, then an AWX instance
3. Wire Vault credentials, the project and inventory
4. Run the PEP-HL-ANS-001 read-only playbook from AWX

**Alternative to weigh first:** Semaphore UI (open source, runs in Docker, no Kubernetes) gives a web UI, schedules and an API for Ansible with far less to run. AWX is the closer match to Tower and the better learning path for Kubernetes; Semaphore is the smaller job. It's already in the vault's link-review list.

### Success Criteria

- AWX reachable on HTTPS, admin login working
- A job template runs the read-only playbook against the inventory, with credentials from Vault
- AWX survives a node reboot; database backed up

## Implementation Plan

### Phase 1: decide AWX vs Semaphore, and the Kubernetes target

### Phase 2: Kubernetes and AWX Operator

### Phase 3: AWX wired to Vault, the repo and inventory

### Phase 4: first job template; JARVIS access designed (not built)

## Testing Strategy

Read-only job templates first; `--check` mode on anything that changes hosts.

## Documentation Requirements

Vault project note and a runbook: install, upgrade (operator version bumps), backup and restore.

## Risks and Mitigation

- Kubernetes adds a whole platform to run: keep it single-node and rebuildable from code.
- Operator upgrades break AWX: pin versions, back up before upgrading.

**Backout:** delete the AWX instance and namespace, or the whole k3s VM; nothing else depends on it until jobs are moved there.

## References

- PEP-HL-ANS-001
- PEP-HL-TOFU-002 (homelab-terraform): VM provisioning
- Vault: `30-projects/homelab-ansible-and-awx.md`, `20-areas/homelab/talos-kubernetes-cluster-rebuild.md`, `30-projects/jarvis/jarvis-access-model.md`

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2026-10-10 | Timo Vlot | Initial draft |
