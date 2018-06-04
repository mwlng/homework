### Deploy Apache Airflow into AWS using Sceptre, Cloudformation and Ansible.

---

#### Using Sceptre and AWS Cloudformation for infrastructure automation

* #### Sceptre AWS Cloudformation tepmlates

  1. VPC by region (eu-west-1)
    - templates/regions/eu-west-1
>     vpc.yaml

  2. Common shared/reusable templates
    - templates/common/
>     iam.yaml (IAM roles)
>     alb.yaml (Application loadbalancer)
>     asg.yaml (Autoscaling group)
>     redisec.yaml (Redis elasticcache)
>     postgres-rdsclus.yaml (RDS Aurora cluster)

  3. Application specific templates
    - templates/apps/airflow
>     sgs.yaml (Security groups)

* #### Sceptre Airflow Cloudformation stacks configuration files
    - config/prod
>      1. airflow-vpc.yaml
>      2. airflow-iam.yaml
>      3. airflow-sgs.yaml
>      4. airflow-alb.yaml
>      5. airflow-asg.yaml
>      6. airflow-postgres.yaml
>      7. airflow-redisec.yaml

* #### How to run

    * step 1: `> pip install sceptre`
    * step 2: Replace 'KeyName' parameter in airflow-asg.yaml with your sshkeypair name
    * step 3: `> sceptre launch-env prod `

---

#### Using Ansible to deploy Airflow

 * step 1:  ` > cd ansible/ `
 * step 2:  `> ./deploy.sh `

---

#### Summary

1. Due to time pressure, I think the quickest way to complete this project within 1~2 days is using Sceptre, AWS Cloudformation and Ansible.

2. Total time spend on this project is ~12-hour. Most time was spending on creating, typing and troubleshooting AWS Cloudformation templates.

3. For the best practice in production, I think below items need to be further follow up:

   - Setup VPN connection to the VPC, so Ansible can make ssh connection to instances using internal private IPs through the VPN.  

   - Remove public IPs on the instances.

   - Create a non self-signed certificate, so users can access it through SSL from the Internet.

   - Need a real public DNS doamin/hostedzone in AWS, so we can create a CNAME record for the ALB.

   - Due to time pressure, I didn't use trophosphere PY templete in this project. In real situation, for example, we can use PY template for creating VPC template dynamically, so we can put it into common/shared folder for reusing (write once, apply anywhere).

   - I used Autoscaling Group in this project, so in real production environment, you can scale up and down the number of t2 type instances based on workload metrics from your monitoring system(Ex: Cloudwatch).

4. Some caveats about using Sceptre:

   - Need to carefully design it's directory layout.

   - Need to balance between the number of CFN stacks created in AWS for each application and the size of cloudformation template file(in #lines of code).
