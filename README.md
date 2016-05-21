# agora_vai

## Servidor

O servidor está rodando em agoravai.querobolsa.space.

### Acessar ssh

    ssh -i staging.pem ubuntu@agoravai.querobolsa.space

### Rodar sinatra app

    sudo service nginx restart

    rvmsudo thin start -s 1 -C /etc/thin/agora_vai.yml -R /home/ubuntu/agora_vai/config.ru


