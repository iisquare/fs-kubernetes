# Kubernetes
kubernetes cluster service

### ��������
- ͨ���嵥������ɾ��
```
kubectl create -f /path/to/template.yaml
kubectl delete -f /path/to/template.yaml
```
- Pod
```
kubectl get pods -n namespace -o wide
kubectl delete pods PODNAME -n namespace
kubectl describe pods PODNAME -n namespace
kubectl logs PODNAME -n namespace
docker exec -it {container-id} /bin/bash
```
- Ingress
```
kubectl get ingress --all-namespaces
```
- Resource
```
kubectl api-resources
kubectl api-resources --namespaced=true
```

### Habor����
- �ϴ�����
```
# ��ȡ����
docker pull k8s.gcr.io/kubernetes-zookeeper:1.0-3.4.10
# ���ɱ�ǩ
docker tag anjia0532/google-containers.kubernetes-zookeeper:1.0-3.4.10 harbor.iisquare.com/gcr/kubernetes-zookeeper:1.0-3.4.10
# ��¼�ֿ�
docker login --username=admin harbor.iisquare.com
# ���;���
docker push harbor.iisquare.com/gcr/kubernetes-zookeeper:1.0-3.4.10
```

### �ο�����
- [gcr.io_mirror](https://github.com/anjia0532/gcr.io_mirror)
