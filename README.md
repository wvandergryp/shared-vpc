# shared-vpc
Shared VPC tutorial
# GCP VPC shared setup using Terraform
Introduction:
As cloud infrastructures grow, optimizing network architecture becomes crucial, especially for managing multiple projects with shared resources. Google Cloud's Shared VPC allows service projects to securely communicate via a centrally managed network in a host project, simplifying security and networking.

In this post, I’ll guide you through deploying a Shared VPC across two service projects using Terraform, including creating VMs and testing their connectivity with iperf3. This setup can be a starting point for more complex architectures, allowing you to expand easily with additional services and projects.

Conclusion:
This Terraform setup is an efficient way to manage shared networking resources across multiple projects in Google Cloud. By using a Shared VPC, teams can streamline network management while maintaining security boundaries between projects. The example provided can be scaled up as needed, making it a great starting point for more complex, multi-project cloud infrastructures.

If you’re looking for a hands-on, scalable network architecture solution for Google Cloud, this setup provides a robust foundation.
