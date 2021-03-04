Terraform
---
Terraform carga los ficheros .tf que se encuentren en la carpeta donde estes, da igual el nombre de los mismos pero para ser ordenados se recomienda el fichero main.tf para el inicio, variables.tf para las mismas y output.tf para los datos que nos tiene que exportar. 

## Los comandos de terraform serian:
 - init : Descargar los plugins necesarios para funcionar. 
 - fmt : formaterar el texto 
 - plan : muestra los cambios a relizar
 - apply : aplica los cambios previa aprobación (esta puede saltarse)
 - show :  muestra todo lo que nos devuelve el plugins. 
 - output : muestra unicamente lo que le indicamos en los ficheros .tf (recomendable usar output.tf)
 - show : nos eneseña el estado de la plataforma
 - validate : valida los datos introducidos en los ficheros .tf.
 - destroy : elimina las máquinas creadas. 
 
## Ficheros
Como comentamos, terraform carga todos los ficheros .tf de la carpeta donde estas sin importar el nombre del mismo, pero es recomendable ponerle nombres que nos sean faciles de saber que contienen. 

El fichero principal (main), tiene que contener 3 datos, estos serian terrafom, provider y resource:

- terraform: indicamos el recurso y su proveedor, estos los podemos ver en la propia web https://registry.terraform.io/browse/providers. 
- provider: indicamos el proveedor a usar sobre los que indicamos anteriormente en terraform
- resource : aqui indicamos los recursos a controlar/dar de alta.

main.tf 
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name # esto es una variable.
  }
}
```
 En el fichero variables.tf es recomendable poner las variables que despues usaremos en el fichero main.tf, en el fichero main.tf tambien podemos poner variables, pero asi queda mas ordenado.  
 variables.tf
 ```
 variable "instance_name" {
  description = "Valor de Name tag para la instancia de EC2"
  type        = string
  default     = "ExampleInstance"
}
 ```
 Y por último el fichero outputs.tf , en este se indica los datos que queremos obtener por pantalla una vez finalice el apply del mismo, tambien podemos llamar a estos datos a través del comando `terraform output`.
 outputs.tf
 ```
 output "instance_id" {
  description = "Id de la instancia a sacar"
  value       = aws_instance.example.id
}

output "la_ip" {
  description = "La ip publica"
  value       = aws_instance.example.public_ip
}

output "public_dns" {
  description = "The public dns"
  value       = aws_instance.example.public_dns
}
 ```
Si nos fijamos en el valor (value) del output indicado anteriormente, podemos ver que es el dato que nos devuelve el comando `terraform show`.


Variables
----
Terraform nos permite usar las variabels de varias maneras, podemos poner un fichero diferente (recordemos que no se puede llamar .tf ya que las cogeria entonces), llamandolas con `-vars-file` o con variables de entorno, estas tienen que empezar con TF_VAR_, es importante tener en cuenta que solo cogera lo que estar despues de TF_VAR_, si creamos la variables TF_VAR_ami, terraform buscara la variable ami. 

Workspaces
---
Terraform nos permite trabajar con diferentes espacios de trabajo o workspaces con los mismos ficheros que tenemos. Las ventajas que tienen son las siguientes: 
 
 - Separación del fichero de estado en los diferentes entornos (Cuando el fichero de estado es muy grande este puede darnos problemas). 
 - Poder trabajar con diferentes entornos (dev,pre y pro) con los mismos ficheros que estamos editando.

Una vez que trabajamos con workspaces y lanzamos un terrafom plan, este crea a carpeta "terraform.tfstate.d/$workspace", almacenando nestas carpetas o arquivo state (estado). 

State
---
Este fichero es muy importante, terraform no consulta en nuestro proveedor la esturctura que esta montada, por lo que terraform genera un fichero de estado con los datos aplicados a través del mismo.
Esto pese a ser una desventaja, tiene la opción de que los recursos criticos (como almacenamiento) no puedan ser borrados a través de terraform de manera accidental.
El fichero de estado contiene datos sensibles por lo que no es recomendable subirlo de manera pública, pero si podemos compartirlo a través de contenedores privados como el s3 de amazon https://www.terraform.io/docs/language/settings/backends/s3.html . 

