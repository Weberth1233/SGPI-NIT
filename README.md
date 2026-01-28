# Sistema de Gestão de Propriedade Intelectual (NIT)

O Sistema de Gestão de Propriedade Intelectual (NIT) foi concebido para otimizar e digitalizar o processo de submissão, acompanhamento e gerenciamento de registros de Propriedade Intelectual (PI) do Núcleo de Inovação Tecnológica (NIT).

A plataforma centraliza a interação entre inventores e administradores, substituindo processos manuais e descentralizados.

---

## Objetivo do Projeto

- Oferecer uma aplicação web para pesquisadores e inventores cadastrarem e acompanharem seus pedidos de Propriedade Intelectual
- Fornecer à equipe do NIT ferramentas para validação e tramitação dos processos
- Centralizar, padronizar e dar transparência ao fluxo de PI

---

## Funcionalidades

### Para Usuários (Pesquisadores / Inventores)

- Cadastro e autenticação
  - Registro completo de dados pessoais
  - Acesso via login e senha

- Submissão de pedidos
  - Criação de novos processos
  - Seleção do tipo de Propriedade Intelectual

- Formulários dinâmicos
  - Campos específicos conforme a categoria da PI
  - Patente, Software, Marca, entre outros

- Coautoria
  - Inclusão de múltiplos autores
  - Acesso de consulta ao processo

- Assinatura digital
  - Download de Termo de Sigilo em PDF
  - Upload do documento assinado
  - Compatível com gov.br

- Acompanhamento
  - Visualização em tempo real do status
  - Correção de pendências com justificativa do NIT

---

### Para Administradores (Equipe NIT)

- Gestão de processos
  - Visualização geral e detalhada dos processos cadastrados

- Controle de acesso
  - Elevação de usuários para perfil administrador

- Validação
  - Revisão técnica de documentos e dados preenchidos

- Tramitação externa
  - Anexo de protocolos do INPI
  - Upload de boletos
  - Comprovantes de pagamento da GRU

---

## Fluxo do Processo

- **Tramitando no NIT (Assinado)**
  - Documentos assinados e enviados pelos autores

- **Recebido**
  - Processo em análise pelo administrador

- **Correção**
  - Solicitação de ajustes com justificativa

- **Finalizado**
  - Conclusão da tramitação interna e externa

---

## Requisitos Técnicos e Não-Funcionais

- Segurança
  - Autenticação protegida
  - Armazenamento seguro de dados e documentos

- Usabilidade
  - Interface intuitiva e de fácil navegação

- Compatibilidade
  - Google Chrome
  - Mozilla Firefox
  - Microsoft Edge

- Disponibilidade
  - Operação 24/7 com alta disponibilidade

---

## Arquitetura de Dados

- **Users**
  - Armazena perfis, credenciais e dados de contato

- **Projects**
  - Entidade central do sistema
  - Dados do formulário armazenados em formato JSON

- **Attachments**
  - Gerencia arquivos, caminhos de armazenamento e tipos de documentos

- **Ip_types**
  - Define as categorias de Propriedade Intelectual
  - Estrutura dos formulários em JSON

- **Addresses**
  - Armazena a localização vinculada ao usuário
