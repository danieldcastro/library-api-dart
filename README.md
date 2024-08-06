
# Documentação da API: Cadastro de Usuários e Livros

A API será criada em 3 linguagens diferentes para criação de portfólio e testes de desempenho.

## Índice

- [Documentação da API: Cadastro de Usuários e Livros](#documentação-da-api-cadastro-de-usuários-e-livros)
  - [Índice](#índice)
  - [As Linguagens e Frameworks:](#as-linguagens-e-frameworks)
  - [Descrição](#descrição)
  - [Ferramentas](#ferramentas)
  - [EndPoints](#endpoints)
    - [User Service](#user-service)
      - [Cadastro de Usuários](#cadastro-de-usuários)
    - [Book Service](#book-service)
      - [ISBN Lookup Service](#isbn-lookup-service)
      - [Book Persistence Service](#book-persistence-service)
      - [Book Query Service](#book-query-service)
      - [User-Book Linkage Service](#user-book-linkage-service)
      - [User-Book Query Service](#user-book-query-service)
  - [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
    - [Diagrama de Arquitetura](#diagrama-de-arquitetura)
  - [Autenticação e Autorização](#autenticação-e-autorização)
  - [Mensagens de Erro](#mensagens-de-erro)
  - [Exemplos de Uso](#exemplos-de-uso)
    - [Registrar Novo Usuário com cURL](#registrar-novo-usuário-com-curl)
    - [Autenticar Usuário com Postman](#autenticar-usuário-com-postman)
  - [Versionamento da API](#versionamento-da-api)
  - [Política de Atualizações e Depreciação](#política-de-atualizações-e-depreciação)
  - [Configuração e Deploy](#configuração-e-deploy)
    - [Requisitos](#requisitos)
    - [Passos para Configuração](#passos-para-configuração)
    - [Deploy](#deploy)
- [Tratamento de Erros e Códigos de Status HTTP](#tratamento-de-erros-e-códigos-de-status-http)
    - [**Códigos de Status HTTP Comuns**](#códigos-de-status-http-comuns)
    - [Exemplos de Tratamento de Erros](#exemplos-de-tratamento-de-erros)
      - [1. **Criar Livro**](#1-criar-livro)
      - [2. **Atualizar Livro**](#2-atualizar-livro)
      - [3. **Excluir Livro**](#3-excluir-livro)
      - [4. **Buscar Livro**](#4-buscar-livro)
      - [5. **Autenticação**](#5-autenticação)
- [Modelagem de Banco de Dados](#modelagem-de-banco-de-dados)
    - [1. Modelo de Dados](#1-modelo-de-dados)
      - [Tabela `users`](#tabela-users)
      - [Tabela `authors`](#tabela-authors)
      - [Tabela `books`](#tabela-books)
      - [Tabela `user_books`](#tabela-user_books)
      - [Tabela `author_books`](#tabela-author_books)
    - [2. Relacionamentos](#2-relacionamentos)
    - [3. Relacionamentos Específicos](#3-relacionamentos-específicos)
      - [Usuários e Livros](#usuários-e-livros)
      - [Livros e Editora](#livros-e-editora)
      - [Livros e Autores](#livros-e-autores)
    - [4. Diagrama de Relacionamento](#4-diagrama-de-relacionamento)
    - [5. Considerações Adicionais](#5-considerações-adicionais)

---

## As Linguagens e Frameworks:
- C# (.NET)
- Dart (Vania)
- (A definir)

## Descrição

A API consiste em diversos micro serviços:

1. **User Service**:
   - Cadastro de usuários
   - Autenticação e autorização
   - Gestão de perfis de usuário

2. **Book Service**:
   - ISBN Lookup Service
   - Book Persistence Service
   - Book Query Service
   - User-Book Linkage Service
   - User-Book Query Service

## Ferramentas

- **Banco de dados**: Será utilizado o banco MariaDB.

## EndPoints

### User Service

#### Cadastro de Usuários

| Objetivo | Rota | Método | Tipo de parâmetros | Parâmetros | Descrição | Resposta Esperada | Autenticação |
|--|--|--|--|--|--|--|--|
| Registrar novo usuário | `/users` | POST | Body | `username` (String), `password` (String), `email` (String) | Cria um novo usuário | `201 Created`, `{ "userId": "string" }` | Não |
| Autenticar usuário | `/auth/login` | POST | Body | `username` (String), `password` (String) | Autentica um usuário e retorna um token | `200 OK`, `{ "token": "string" }` | Não |
| Obter perfil de usuário | `/users/{userId}` | GET | URL | `userId` (String) | Retorna os dados do usuário | `200 OK`, `{ "userId": "string", "username": "string", "email": "string" }` | Sim (Bearer Token) |
| Atualizar perfil de usuário | `/users/{userId}` | PUT | URL + Body | `userId` (String), `profileData` (Object) | Atualiza os dados do perfil do usuário | `200 OK`, `{ "userId": "string", "username": "string", "email": "string" }` | Sim (Bearer Token) |
| Deletar usuário | `/users/{userId}` | DELETE | URL | `userId` (String) | Remove um usuário | `204 No Content` | Sim (Bearer Token) |

### Book Service

#### ISBN Lookup Service

| Objetivo | Rota | Método | Tipo de parâmetros | Parâmetros | Descrição | Resposta Esperada | Autenticação |
|--|--|--|--|--|--|--|--|
| Buscar dados por ISBN | `/isbn/{isbn}` | GET | URL | `isbn` (String) | Busca dados de um livro por ISBN em uma API externa | `200 OK`, `{ "title": "string", "author": "string", "publisher": "string" }` | Sim (Bearer Token) |

#### Book Persistence Service

| Objetivo | Rota | Método | Tipo de parâmetros | Parâmetros | Descrição | Resposta Esperada | Autenticação |
|--|--|--|--|--|--|--|--|
| Salvar dados do livro | `/books` | POST | Body | `isbn` (String), `title` (String), `author` (String), `customData` (Object) | Salva os dados do livro no banco | `201 Created`, `{ "bookId": "string" }` | Sim (Bearer Token) |

#### Book Query Service

| Objetivo | Rota | Método | Tipo de parâmetros | Parâmetros | Descrição | Resposta Esperada | Autenticação |
|--|--|--|--|--|--|--|--|
| Buscar livro por ISBN | `/books/isbn/{isbn}` | GET | URL | `isbn` (String) | Busca um livro por ISBN no banco | `200 OK`, `{ "isbn": "string", "title": "string", "author": "string" }` | Sim (Bearer Token) |
| Buscar livro por título | `/books/title/{title}` | GET | URL | `title` (String) | Busca um livro por título no banco | `200 OK`, `{ "isbn": "string", "title": "string", "author": "string" }` | Sim (Bearer Token) |
| Buscar livro por autor | `/books/author/{author}` | GET | URL | `author` (String) | Busca um livro por autor no banco | `200 OK`, `{ "isbn": "string", "title": "string", "author": "string" }` | Sim (Bearer Token) |

#### User-Book Linkage Service

| Objetivo | Rota | Método | Tipo de parâmetros | Parâmetros | Descrição | Resposta Esperada | Autenticação |
|--|--|--|--|--|--|--|--|
| Vincular livro ao usuário | `/users/{userId}/books` | POST | URL + Body | `userId` (String), `bookId` (String) | Vincula um livro ao usuário | `200 OK`, `{ "linkId": "string" }` | Sim (Bearer Token) |

#### User-Book Query Service

| Objetivo | Rota | Método | Tipo de parâmetros | Parâmetros | Descrição | Resposta Esperada | Autenticação |
|--|--|--|--|--|--|--|--|
| Buscar livros vinculados ao usuário | `/users/{userId}/books` | GET | URL | `userId` (String) | Busca livros vinculados a um usuário | `200 OK`, `{ "books": [ { "isbn": "string", "title": "string", "author": "string" } ] }` | Sim (Bearer Token) |

## Visão Geral da Arquitetura

A arquitetura é baseada em micro serviços, onde cada serviço é responsável por uma parte específica da lógica de negócios. Os serviços interagem entre si através de chamadas de API.

### Diagrama de Arquitetura

![Diagrama de Arquitetura](url_do_diagrama)

## Autenticação e Autorização

A API utiliza autenticação baseada em tokens JWT. Para acessar os endpoints que requerem autenticação, o cliente deve incluir o token no cabeçalho da requisição como segue:

Authorization: Bearer **token**

## Mensagens de Erro

| Código de Status | Mensagem | Descrição |
|--|--|--|
| 400 | Bad Request | A requisição está malformada ou faltam parâmetros obrigatórios. |
| 401 | Unauthorized | Token de autenticação ausente ou inválido. |
| 404 | Not Found | O recurso solicitado não foi encontrado. |
| 500 | Internal Server Error | Ocorreu um erro no servidor. |

## Exemplos de Uso

### Registrar Novo Usuário com cURL

```sh
curl -X POST "https://api.exemplo.com/users" -H "Content-Type: application/json" -d '{
    "username": "johndoe",
    "password": "password123",
    "email": "johndoe@example.com"
}'
```


### Autenticar Usuário com Postman

1. Defina o método como POST.
2. Defina a URL como `https://api.exemplo.com/auth/login`.
3. No Body, selecione raw e JSON, e inclua:

```json
{
    "username": "johndoe",
    "password": "password123"
}
```

## Versionamento da API

A API utiliza versionamento baseado em URL. Por exemplo:

```
https://api.exemplo.com/v1/users
```

## Política de Atualizações e Depreciação

Novas versões serão lançadas com mudanças significativas. Endpoints desatualizados continuarão disponíveis por um período de 6 meses após o anúncio da depreciação.

## Configuração e Deploy

### Requisitos

- MariaDB
- Servidor web compatível com as linguagens escolhidas (ex: IIS para .NET, Apache para Dart)

### Passos para Configuração

1. Clone o repositório do código-fonte.
2. Configure o banco de dados MariaDB e crie os esquemas necessários.
3. Configure as variáveis de ambiente necessárias (ex: conexão com o banco de dados, chaves de API externas).
4. Compile e inicie cada serviço conforme as instruções específicas da linguagem e framework escolhidos.

### Deploy

1. Empacote a aplicação para o ambiente de produção.
2. Faça o deploy da aplicação nos servidores designados.
3. Monitore a aplicação para garantir que está funcionando corretamente.

> Este documento fornece uma visão completa e detalhada da API, abrangendo todos os aspectos essenciais e garantindo que os desenvolvedores tenham todas as informações necessárias para utilizar e integrar a API eficazmente.


Com os novos campos adicionados, o modelo de dados para a tabela `books` precisa ser atualizado para refletir esses requisitos. Aqui está a versão revisada do modelo de dados e o relacionamento com as novas informações:


Claro! Vou adicionar uma seção na documentação da modelagem de banco de dados para explicar os tipos de relacionamentos e como eles se aplicam às entidades no seu sistema.

# Tratamento de Erros e Códigos de Status HTTP

### **Códigos de Status HTTP Comuns**

- **200 OK**
  - **Descrição**: A requisição foi bem-sucedida.
  - **Exemplo de Uso**: Retorno de dados após uma busca bem-sucedida, ou confirmação de criação ou atualização bem-sucedida de um recurso.

- **201 Created**
  - **Descrição**: O recurso foi criado com sucesso.
  - **Exemplo de Uso**: Retorno após a criação de um novo livro ou usuário.

- **204 No Content**
  - **Descrição**: A requisição foi bem-sucedida, mas não há conteúdo a retornar.
  - **Exemplo de Uso**: Exclusão bem-sucedida de um recurso.

- **400 Bad Request**
  - **Descrição**: A requisição não pôde ser entendida devido a sintaxe inválida ou parâmetros incorretos.
  - **Exemplo de Uso**: Dados inválidos enviados na criação ou atualização de um livro ou usuário. 
  - **Detalhes**: Mensagens de erro devem detalhar o problema com a requisição.

- **401 Unauthorized**
  - **Descrição**: Falta de autenticação ou credenciais inválidas.
  - **Exemplo de Uso**: Requisições que exigem autenticação e não fornecem credenciais válidas.

- **403 Forbidden**
  - **Descrição**: O servidor entendeu a requisição, mas se recusa a atendê-la. O usuário não tem permissão para acessar o recurso.
  - **Exemplo de Uso**: Tentativa de acesso a um recurso para o qual o usuário não tem permissão.

- **404 Not Found**
  - **Descrição**: O recurso solicitado não foi encontrado.
  - **Exemplo de Uso**: Tentativa de acessar um livro ou usuário que não existe no banco de dados.

- **409 Conflict**
  - **Descrição**: A requisição não pôde ser concluída devido a um conflito com o estado atual do recurso.
  - **Exemplo de Uso**: Tentativa de criar um livro com um ISBN que já existe no banco de dados.

- **422 Unprocessable Entity**
  - **Descrição**: Os dados fornecidos são semânticamente inválidos.
  - **Exemplo de Uso**: Dados inválidos que não podem ser processados, como um ISBN mal formatado.

- **500 Internal Server Error**
  - **Descrição**: Ocorreu um erro inesperado no servidor.
  - **Exemplo de Uso**: Erros gerais que não podem ser classificados em outras categorias.

- **503 Service Unavailable**
  - **Descrição**: O serviço está temporariamente indisponível, geralmente devido a manutenção ou sobrecarga.
  - **Exemplo de Uso**: A API está fora do ar para manutenção programada.

### Exemplos de Tratamento de Erros

#### 1. **Criar Livro**

- **Requisição Bem-Sucedida**:
  - **Status**: 201 Created
  - **Resposta**: `{ "message": "Livro criado com sucesso.", "book_id": 123 }`

- **Dados Inválidos**:
  - **Status**: 400 Bad Request
  - **Resposta**: `{ "error": "Dados inválidos. ISBN é obrigatório." }`

- **ISBN Já Existente**:
  - **Status**: 409 Conflict
  - **Resposta**: `{ "error": "ISBN já existente." }`

#### 2. **Atualizar Livro**

- **Requisição Bem-Sucedida**:
  - **Status**: 200 OK
  - **Resposta**: `{ "message": "Livro atualizado com sucesso." }`

- **Livro Não Encontrado**:
  - **Status**: 404 Not Found
  - **Resposta**: `{ "error": "Livro não encontrado." }`

- **Dados Inválidos**:
  - **Status**: 422 Unprocessable Entity
  - **Resposta**: `{ "error": "Dados inválidos. Verifique o formato do ISBN." }`

#### 3. **Excluir Livro**

- **Requisição Bem-Sucedida**:
  - **Status**: 204 No Content
  - **Resposta**: Nenhum conteúdo no corpo da resposta.

- **Livro Não Encontrado**:
  - **Status**: 404 Not Found
  - **Resposta**: `{ "error": "Livro não encontrado." }`

#### 4. **Buscar Livro**

- **Requisição Bem-Sucedida**:
  - **Status**: 200 OK
  - **Resposta**: `{ "book_id": 123, "title": "Exemplo de Livro", ... }`

- **Livro Não Encontrado**:
  - **Status**: 404 Not Found
  - **Resposta**: `{ "error": "Livro não encontrado." }`

#### 5. **Autenticação**

- **Credenciais Inválidas**:
  - **Status**: 401 Unauthorized
  - **Resposta**: `{ "error": "Credenciais inválidas." }`

- **Permissão Negada**:
  - **Status**: 403 Forbidden
  - **Resposta**: `{ "error": "Você não tem permissão para acessar este recurso." }`

# Modelagem de Banco de Dados

### 1. Modelo de Dados

#### Tabela `users`

| Coluna        | Tipo         | Descrição                        |
|---------------|--------------|----------------------------------|
| `id`          | INT          | Identificador único do usuário (PK) |
| `name`        | VARCHAR(50)  | Nome de usuário                   |
| `password`    | VARCHAR(255) | Senha do usuário                  |
| `email`       | VARCHAR(100) | Email do usuário                  |
| `created_at`  | TIMESTAMP    | Data e hora de criação do usuário |
| `updated_at`  | TIMESTAMP    | Data e hora da última atualização |

#### Tabela `authors`

| Coluna        | Tipo         | Descrição                        |
|---------------|--------------|----------------------------------|
| `id`          | INT          | Identificador único do autor (PK) |
| `name`        | VARCHAR(50)  | Nome de autor                     |
| `biography`   | TEXT         | Biografia do autor                |
| `created_at`  | TIMESTAMP    | Data e hora de criação do usuário |
| `updated_at`  | TIMESTAMP    | Data e hora da última atualização |

#### Tabela `books`

| Coluna           | Tipo         | Descrição                                      |
|------------------|--------------|------------------------------------------------|
| `id`             | INT          | Identificador único do livro (PK)              |
| `isbn`           | VARCHAR(20)  | ISBN do livro                                  |
| `title`          | VARCHAR(255) | Título do livro                                |
| `subtitle`       | VARCHAR(255) | Subtítulo do livro (opcional)                  |
| `series`         | VARCHAR(255) | Série ou coleção do livro (opcional)           |
| `volume`         | VARCHAR(20)  | Volume do livro na série (opcional)            |
| `translator`     | VARCHAR(255) | Tradutor do livro (opcional)                   |
| `language`       | VARCHAR(50)  | Idioma do livro                                |
| `publisher`      | VARCHAR(255) | Editora do livro                               |
| `edition`        | VARCHAR(50)  | Edição do livro                                |
| `year`           | YEAR         | Ano de publicação                              |
| `pages`          | INT          | Número de páginas                              |
| `synopsis`       | TEXT         | Sinopse do livro                               |
| `genres`         | VARCHAR(255) | Gêneros do livro (separados por vírgula)       |
| `created_at`     | TIMESTAMP    | Data e hora de criação do livro                |
| `updated_at`     | TIMESTAMP    | Data e hora da última atualização do livro     |

#### Tabela `user_books`

| Coluna        | Tipo        | Descrição                          |
|---------------|-------------|------------------------------------|
| `user_id`     | INT         | Identificador do usuário (FK)       |
| `book_id`     | INT         | Identificador do livro (FK)         |
| `linked_at`   | TIMESTAMP   | Data e hora em que o livro foi vinculado ao usuário |

#### Tabela `author_books`

| Coluna        | Tipo        | Descrição                          |
|---------------|-------------|------------------------------------|
| `author_id`   | INT         | Identificador do autor (FK)        |
| `book_id`     | INT         | Identificador do livro (FK)        |
| `linked_at`   | TIMESTAMP   | Data e hora em que o livro foi vinculado ao autor |

### 2. Relacionamentos

Para determinar o tipo de relacionamento entre entidades, consideramos as seguintes definições:

- **Relacionamento 1 para N (Um para Muitos)**:
  - **Descrição**: Uma entidade em uma tabela pode estar associada a várias entidades em outra tabela, mas cada entidade na segunda tabela está associada a no máximo uma entidade na primeira tabela.
  - **Exemplo**: Um autor pode escrever vários livros, mas cada livro tem apenas um autor. Assim, o relacionamento entre `authors` e `books` é 1 para N.

- **Relacionamento N para 1 (Muitos para Um)**:
  - **Descrição**: Várias entidades em uma tabela estão associadas a uma única entidade em outra tabela. É basicamente o oposto do relacionamento 1 para N.
  - **Exemplo**: Muitos livros podem ser editados pela mesma editora. Portanto, o relacionamento entre `books` e `publishers` é N para 1.

- **Relacionamento N para N (Muitos para Muitos)**:
  - **Descrição**: Entidades em uma tabela podem estar associadas a várias entidades em outra tabela e vice-versa. Para implementar isso, é necessário uma tabela intermediária (ou de junção) para gerenciar as associações.
  - **Exemplo**: Um usuário pode ter vários livros e um livro pode ser associado a vários usuários. O relacionamento entre `users` e `books` é N para N, e a tabela `user_books` é a tabela de junção que gerencia essas associações.

### 3. Relacionamentos Específicos

#### Usuários e Livros

- **Relacionamento**: N para N
- **Justificativa**: Um usuário pode ter vários livros e um livro pode ser associado a vários usuários. A tabela intermediária `user_books` gerencia esse relacionamento.

#### Livros e Editora

- **Relacionamento**: N para 1
- **Justificativa**: Muitos livros podem ser publicados pela mesma editora, mas cada livro é publicado por apenas uma editora.

#### Livros e Autores

- **Relacionamento**: 1 para N
- **Justificativa**: Cada livro tem um autor, mas um autor pode ter vários livros. Se o modelo permitir vários autores por livro, o relacionamento seria N para N, e uma tabela de junção entre autores e livros seria necessária.

### 4. Diagrama de Relacionamento

```plaintext
+------------+       +-------------+
|   users    |       |    books    |
+------------+       +-------------+
| user_id (PK)|---+---| book_id (PK)|
| username    |   |   | isbn        |
| password    |   |   | title       |
| email       |   |   | subtitle    |
| created_at  |   |   | series      |
| updated_at  |   |   | volume      |
+------------+       | author      |
       |             | translator  |
       |             | language    |
       |             | publisher   |
       |             | edition     |
       |             | year        |
       |             | pages       |
       |             | synopsis    |
       |             | genres      |
       |             | created_at  |
       |             | updated_at  |
       |             +-------------+
       |
       |
       +----------------------+
                 |
                 |
            +--------------------+
            |    user_books      |
            +--------------------+
            | user_id (FK)       |
            | book_id (FK)       |
            | linked_at          |
            +--------------------+
```

### 5. Considerações Adicionais

1. **Índices**:
   - Crie índices em `user_id` e `book_id` na tabela `user_books` para melhorar a performance das consultas.

2. **Integridade Referencial**:
   - Defina chaves estrangeiras (`FOREIGN KEY`) em `user_books` para garantir que `user_id` e `book_id` correspondam a registros válidos nas tabelas `users` e `books`, respectivamente.

3. **Validação e Normalização**:
   - Certifique-se de que os dados são validados corretamente e que o modelo está normalizado para evitar redundâncias e garantir a integridade dos dados.

4. **Escalabilidade**:
   - Dependendo do volume de dados e das consultas, considere otimizar índices e realizar particionamento se necessário.

---
