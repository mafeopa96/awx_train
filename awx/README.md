# AWX Post-Deployment Scanner

Herramienta automatizada para ejecutar escaneos post-despliegue en entornos On-Premise y Kubernetes/GKE.

Eb8OKz9UBnkiNELM7c3H8CYW7RxIdpge

## 🚀 Quick Start

### Instalación

```bash
# Clonar o descargar el proyecto
cd awx-post-deployment-scan

# Ejecutar setup
chmod +x setup.sh
./setup.sh

# Probar localmente
ansible-playbook playbooks/post_deployment_scan.yml \
  -e "deployment_type=onprem" \
  --check

# Ejecución real
ansible-playbook playbooks/post_deployment_scan.yml \
  -e "deployment_type=onprem"

# Ver resultados
ls -la /tmp/scan_reports/
firefox /tmp/scan_reports/[timestamp]/scan_report.html
