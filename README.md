# docker-k8s-challenge-master
## Part1:- Fix the Dockerfile and Go Application
### 1. Change the CMD instruction in Dockerfile to point to the correct location "/app/myapp" instead of "/bin/myapp"
### 2. Create a Docker Compose to run redis and the Go app and run it
        sudo docker-compose up -d
### 3. Check containers Running status
        sudo docker container ps -a
![Containers Running Status](https://github.com/user-attachments/assets/5b3bc1c5-dcba-47b5-809d-b3d97f9d3f5e)
### 4. Access App through web and check it is working as expected
![AppWorkingAfterDockerSolve](https://github.com/user-attachments/assets/cf80b418-3130-43a4-8f54-1f33bf55f0b1)
### 5. Check App container logs to see the incoming requests
        sudo docker container logs c04c2ff22ae4
![App Container Logs](https://github.com/user-attachments/assets/de5f49b2-4537-4c7e-91dc-2183f26d8eb9)
### 6. Check the Images size before optimize it's size
![Images Before Size Optimize](https://github.com/user-attachments/assets/dd2734f2-46fc-4d98-8954-f74f33240034)
### 7. Modify Dockerfile to use Multistage building to optimize image size
### 8. Check the Images size after optimize it's size
![Images After Size Optimize](https://github.com/user-attachments/assets/5324a4b4-d515-4927-b5b6-a265f581e869)
### 9. Push Optimized size image to my docker hub
        sudo docker tag docker-k8s-challenge-master-go-app:latest marwansabry/go-app:latest
        sudo docker push marwansabry/go-app:latest
![Image on DockerHub](https://github.com/user-attachments/assets/e96e8826-f96b-44c3-b17a-f9a042a193e2)
---
## Part2:- Deploy to Kubernetes
### 1. Create Yaml files for these components:-
#### - app-namespace (Create app namespace)
#### - db-namespace (Create db namespace)
#### - redis ( create Redis as a StatefulSet in the db namespace and Use a PersistentVolumeClaim for storage)
#### - redis-service (crete Redis Service)
#### - go-app (Creat Go app as a Deployment in the app namespace)
#### - go-app-service (Crete Go app NodePort Service)
### 2. Apply these Yaml files.
        sudo kubectl apply -f .
### 3. Check the pods after created
        sudo kubectl get pods -o wide -n app
        sudo kubectl get pods -o wide -n db
![Get Pods](https://github.com/user-attachments/assets/9e35f72f-9604-4b36-a606-402d0fcde57a)
### 4. Check the NodePort Service after created
        sudo kubectl get service go-app-service -n app
![App NodePort Service](https://github.com/user-attachments/assets/2e892ada-56ea-4301-9c92-359c0ba03de9)
### 5. Check the ClusterIP Redis Service after created
        sudo kubectl get service redis-service -n db
![db ClusterIP service](https://github.com/user-attachments/assets/0aedff0b-299f-452f-834f-ab983d3f3214)
### 6. Describe Pods and Services
        sudo kubectl describe pod go-app-deployment-9c4ccfc8d-z46tp -n app
![Describe app pod](https://github.com/user-attachments/assets/f9edb696-660c-4f22-8976-258a0cf7905d)

        sudo kubectl describe pod redis-statefulset-0 -n db
![Describe db pod](https://github.com/user-attachments/assets/21d32791-2d94-4fdb-beef-24de1b171dac)

        sudo kubectl describe service go-app-service -n app
![Describe app NodePort service](https://github.com/user-attachments/assets/33dcf5a9-fc15-4597-b995-03e4ae52ae75)

        sudo kubectl describe service redis-service -n db
![Describe db ClusterIP service](https://github.com/user-attachments/assets/3dbd0afe-b8ee-456f-a662-2d621e80126a)
### 7. Create Test Pod to access app pod
#### - Apply test-pod.yaml
        sudo kubectl apply -f test-pod.yaml
#### - Get Pod after created
        sudo kubectl get pods -n app
![Get Test Pod](https://github.com/user-attachments/assets/94458f0d-2917-4002-9c4e-610677d3304d)
#### - Run Curl command from the test pod 
        sudo kubectl exec -it go-app-test-pod -n app -- /bin/sh
        curl http://10.103.222.238:80
![Result of access from test pod](https://github.com/user-attachments/assets/f3d671e7-cae2-4406-90b8-ce3ce690e395)
### 8. View logs for both app and db pods after access from the test pod
        sudo kubectl logs go-app-deployment-9c4ccfc8d-z46tp -n app
![View app logs after access from the test pod](https://github.com/user-attachments/assets/2ab3e10d-64d0-4aec-b6dc-3b4f0252726a)

        sudo kubectl logs redis-statefulset-0 -n db
![View db logs after access from the test pod](https://github.com/user-attachments/assets/67dc04ab-867e-491e-aeba-cbe646faaf30)
