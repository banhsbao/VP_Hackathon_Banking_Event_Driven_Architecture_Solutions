## Terraform Infrastructure Setup Guide

Welcome to the Terraform Infrastructure Setup Guide for the VP Hackathon project. This document provides step-by-step instructions on how to initialize and deploy infrastructure using Terraform.
![image](readme.md)

### Prerequisites

Before proceeding, ensure you have the following:

- Terraform installed on your machine. You can download it from here.
- AWS CLI configured with necessary permissions. You can install and configure it by following the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

### 1. Basic Infrastructure Setup

#### Steps:

1.  Navigate to the directory `terraform/vp-hackathon/infra`.
2.  Run the command `terraform init` to initialize the environment and tools required for infrastructure setup.
3.  After initialization, execute `terraform plan`.
4.  Upon completion, apply the changes using `terraform apply -auto-approve`.

#### Description:

This phase will provision basic infrastructure components such as VPN, RDS, DynamoDB, SES, Route 53, etc.

### 2. CICD Environment Setup

#### Steps:

1.  Go to the directory `terraform/vp-hackathon/cicd`.
2.  Initiate the environment setup by running `terraform init`.
3.  Verify the plan by executing `terraform plan`.
4.  Apply the changes using `terraform apply -auto-approve`.
5.  Access AWS connection settings at [AWS CodeSuite Settings](https://ap-southeast-1.console.aws.amazon.com/codesuite/settings/connections).
6.  Click on "github-bh-connection".
7.  Press "Update pending connection".
8.  Choose "Install a new app".
9.  Log in to your GitHub account and select the repository.
10. Grant permissions to AWS.

#### Description:

This step sets up the Continuous Integration and Continuous Deployment (CICD) environment.

### 3. Build Image and Deploy with Serverless Framework

#### Steps:

1.  Navigate to your project folder.
2.  Ensure your machine is connected to AWS CLI.
3.  Visit [Serverless Framework](https://www.serverless.com/) and access the access key section. Generate a new key and save it.
4.  Execute the provided commands in your terminal.
5.  Run `sh deploy_local.sh` and wait for the process to complete.

#### Description:

This phase involves building the image and deploying it using the Serverless Framework.

### 4. Deploy AWS Service Infrastructure

#### Steps:

1.  Navigate to the directory `terraform/vp-hackathon/dev`.
2.  Initialize the application setup using `terraform init`.
3.  Verify the plan with `terraform plan`.
4.  Apply the changes using `terraform apply -auto-approve`.

#### Description:

This step deploys services and applications such as Step Functions, AWS connections, etc.

### Conclusion

Congratulations! You have successfully set up the infrastructure for the VP Hackathon project using Terraform. If you encounter any issues or have questions, feel free to reach out to the project team.

# Vietnamese version

## Hướng Dẫn Thiết Lập Cơ Sở Hạ Tầng với Terraform

Chào mừng bạn đến với **Hướng Dẫn Thiết Lập Cơ Sở Hạ Tầng với Terraform** cho dự án VP Hackathon. Tài liệu này cung cấp hướng dẫn từng bước về cách khởi tạo và triển khai cơ sở hạ tầng bằng Terraform.

### Yêu Cầu Tiên Quyết

Trước khi tiếp tục, đảm bảo bạn đã có:

- Terraform được cài đặt trên máy tính của bạn. Bạn có thể tải nó từ [đây](https://terraform.io/downloads.html).
- AWS CLI được cấu hình với các quyền cần thiết. Bạn có thể cài đặt và cấu hình bằng cách làm theo [hướng dẫn này](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

### 1. Thiết Lập Cơ Sở Hạ Tầng Cơ Bản

#### Các Bước:

1.  Di chuyển đến thư mục `terraform/vp-hackathon/infra`.
2.  Chạy lệnh `terraform init` để khởi tạo môi trường và công cụ cần thiết cho việc thiết lập cơ sở hạ tầng.
3.  Sau khi khởi tạo, thực hiện `terraform plan`.
4.  Khi hoàn thành, áp dụng các thay đổi bằng `terraform apply -auto-approve`.

#### Mô Tả:

Giai đoạn này sẽ cung cấp các thành phần cơ sở hạ tầng cơ bản như VPN, RDS, DynamoDB, SES, Route 53, v.v.

### 2. Thiết Lập Môi Trường CICD

#### Các Bước:

1.  Đi đến thư mục `terraform/vp-hackathon/cicd`.
2.  Bắt đầu thiết lập môi trường bằng cách chạy `terraform init`.
3.  Xác minh kế hoạch bằng cách thực thi `terraform plan`.
4.  Áp dụng các thay đổi bằng `terraform apply -auto-approve`.
5.  Truy cập cài đặt kết nối AWS tại [Cài Đặt AWS CodeSuite](https://ap-southeast-1.console.aws.amazon.com/codesuite/settings/connections).
6.  Nhấp vào "github-bh-connection".
7.  Nhấn "Update pending connection".
8.  Chọn "Install a new app".
9.  Đăng nhập vào tài khoản GitHub của bạn và chọn kho lưu trữ.
10. Cấp quyền cho AWS.

#### Mô Tả:

Bước này thiết lập môi trường Liên tục Tích hợp và Triển khai Liên tục (CICD).

### 3. Xây Dựng Hình Ảnh và Triển Khai với Serverless Framework

#### Các Bước:

1.  Di chuyển đến thư mục dự án của bạn.
2.  Đảm bảo máy của bạn đã được kết nối với AWS CLI.
3.  Truy cập [Serverless Framework](https://www.serverless.com/) và truy cập phần khóa truy cập. Tạo khóa mới và lưu lại.
4.  Thực hiện các lệnh được cung cấp trong cửa sổ terminal của bạn.
5.  Chạy `sh deploy_local.sh` và đợi quá trình hoàn tất.

#### Mô Tả:

Giai đoạn này liên quan đến việc xây dựng hình ảnh và triển khai nó bằng Serverless Framework.

### 4. Triển Khai Cơ Sở Hạ Tầng Dịch Vụ AWS

#### Các Bước:

1.  Di chuyển đến thư mục `terraform/vp-hackathon/dev`.
2.  Khởi tạo thiết lập ứng dụng bằng `terraform init`.
3.  Xác minh kế hoạch bằng `terraform plan`.
4.  Áp dụng các thay đổi bằng `terraform apply -auto-approve`.

#### Mô Tả:

Bước này triển khai các dịch vụ và ứng dụng như Step Functions, kết nối AWS, v.v.

### Kết Luận

Xin chúc mừng! Bạn đã thành công thiết lập cơ sở hạ tầng cho dự án VP Hackathon bằng Terraform. Nếu bạn gặp bất kỳ vấn đề hoặc có câu hỏi, đừng ngần ngại liên hệ với nhóm dự án.
