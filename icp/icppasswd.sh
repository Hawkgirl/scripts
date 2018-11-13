if [ $# != 2 ]; then
	echo 'provide old password and new password'
	exit 1
fi
old_password=$1
new_password=$2
kubectl config set-credentials cluster-admin --username=admin --password=$old_password
base64_password=`echo $new_password | base64`
kubectl --kubeconfig /var/lib/kubelet/kubelet-config -n kube-system get secrets platform-auth-idp-credentials --output=json | jq  --arg jq_pass "$base64_password"  '.data.admin_password=$jq_pass' | kubectl apply -f -
kubectl -n kube-system delete pods -l k8s-app=auth-idp
