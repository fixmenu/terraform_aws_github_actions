#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install docker -y
sudo usermod -a -G docker ec2-user
#yum install -y httpd
#systemctl start httpd
#systemctl enable httpd
#echo "<html><head><style>  body {    background-color: black;    display: flex;    justify-content: center;    align-items: center;    height: 100vh;  } h1 {    font-size: 5em;    background: -webkit-linear-gradient(      left,      red,      orange,      yellow,      green,      blue,      indigo,      violet    );    -webkit-background-clip: text;    background-clip: text;    -webkit-text-fill-color: transparent;    text-fill-color: transparent;    background-size: 500% auto;    animation: textShine 5s ease-in-out infinite alternate;  }  @keyframes textShine {    0% {      background-position: 0% 50%;    }    100% {      background-position: 100% 50%;    }  }</style> </head> <body><h1>codeslag</h1> </body> </html>" > /var/www/html/index.html