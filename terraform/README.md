1.If u wrongly deleted the terraform.tfstate, below steps helps to bring back the state one by one

For AWS instance
```
provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-5741097"
  instance_type = "t2.micro"
}
```
To bring back the state file use the below command.
```
terraform import aws_instance.example i-1111teste
```

For Helm
```
resource "helm_release" "test_chart" {
    name  = "test"
    chart = "./chart"
}

```
To bring back the state file use the below command.

***default*** -> **namespace**
```
terraform import helm_release.test_chart default/test
```
