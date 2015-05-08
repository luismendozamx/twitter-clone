# Tutorial de Rails

Crear un mini clon de Twitter.

## Dependencias

Para poder seguir este tutorial se requiere:
* Instalar Ruby > 2.1.2
* Intsalar Rails > 4.1.6
* Instalar Postrgesql (Se puede utilizar mysql o sqlite)
* Se asume un sistema operativo Unix (Linux o Mac)

## Pasos a seguir

### Crear Aplicación

```sh
rails new twitter --database=postgresql --skip-test-unit
rake db:create
rake db:migrate
```

Agregar gems iniciales. En Gemfile:

```ruby
gem 'bootstrap-sass', '~> 3.3.4'
gem 'simple_form'
```

Instalar gems. Ejecutar:
```sh
bundle install
```
Renombrar app/assets/stylesheets/application.css a app/assets/stylesheets/application.scss

Incluir en app/assets/stylesheets/application.css

```sass
@import "bootstrap-sprockets";
@import "bootstrap";
```
Incluir en app/assets/javascripts/application.js (Después de //= require jquery)

```sass
//= require bootstrap-sprockets
```

Crear generador de Simple Form
```sh
rails generate simple_form:install --bootstrap
```

Reiniciar el servidor para mostrar cambios.

### Crear el primer scaffold
```sh
rails generate scaffold status content:string
```

Generar migración en la base
```sh
rake db:migrate
```
### Mejorar nuestras vistas

Borrar el contenido de app/assets/stylesheets/scaffolds.css.scss

En app/views/layouts/application.html.erb cambiar el código dentro de <body> por:

```erb
<nav class="navbar navbar-default">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Twitter</a>
    </div>

    <div class="collapse navbar-collapse" id="navbar-collapse">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#">Link</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container">
  <%= yield %>
</div>
```

En app/views/statuses/index.html.erb sustituir todo el código por:

```erb
<%= link_to 'Post New Tweet', new_status_path, class: "btn btn-default" %>

<h1>Twitter Feed</h1>

<% @statuses.each do |status| %>
<div class="col-sm-12 tweet">
  <p><%= status.content %></p>
  <div class="tweet-info">
    <%= link_to 'Show', status %> |
    <%= link_to 'Edit', edit_status_path(status) %> |
    <%= link_to 'Destroy', status, method: :delete, data: { confirm: 'Are you sure?' } %>
  </div>
</div>
<% end %>
```

Cambiar link show por un link de hace cuanto fue publicado el mensaje.
En app/views/statuses/index.html.erb:

```erb
...

<p><%= status.content %></p>
<%= link_to time_ago_in_words(status.created_at), status %>
<div class="tweet-info">
  <%= link_to 'Edit', edit_status_path(status) %> |
  <%= link_to 'Destroy', status, method: :delete, data: { confirm: 'Are you sure?' } %>
</div>

...
```

### Modificar Rutas

En config/routes.rb agregar:
```ruby
root 'statuses#index'
```

Modificar navegación. En app/views/layouts/application.html.erb cambiar:
```erb
<a class="navbar-brand" href="#">Twitter</a>
```
por
```erb
<%= link_to "Twitter", root_path, class: "navbar-brand" %>
```

### Ordenar Tweets
En app/controllers/statuses_controllers.rb cambiar el contenido de index por:
```ruby
@statuses = Status.order('created_at DESC').all
```

### Generar información aleatoria y paginación
En Gemfile agregar
```ruby
gem 'faker', group: :development
gem 'will_paginate'
```
Ejecutar
```sh
bundle install
```

Para usar Faker en db/seeds.rb agregar:
```ruby
50.times do
  content = Faker::Lorem.sentence(5)
  Status.create!(content: content)
end
```

Apagar servidor y correr:
```sh
rake db:reset
```

Para agregar paginación en app/controllers/statuses_controllers.rb

En app/controllers/statuses_controllers.rb cambiar el contenido de index por:
```ruby
@statuses = Status.paginate(page: params[:page], per_page: 10).order('created_at DESC').all
```
Reiniciar servidor

En app/views/statuses/index.html.erb agregar:
```ruby
<%= will_paginate %>
```

## Parte 2

### Usuarios y Autenticación

Instalar [Devise](https://github.com/plataformatec/devise) para autenticación de usuarios.

En Gemfile agregar:

```ruby
gem 'devise'
```

Intsalar en nuestra aplicación:

```sh
bundle install
```

Para empezar a utilizar devise debemos configurar varios pasos. Correr:

```sh
rails generate devise:install
```
Seguir los pasos que devise nos indica.

Agregar en config/environments/development.rb

```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

En app/views/layout/application.html.erb agregar

```erb
<% if flash[:notice] %>
  <div class="alert alert-success alert-dismissible" role="alert">
    <div class="container">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <p><%= notice %></p>
    </div>
  </div>
<% end %>

<% if flash[:alert] %>
  <div class="alert alert-danger alert-dismissible" role="alert">
    <div class="container">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <p><%= alert %></p>
    </div>
  </div>
<% end %>
```

Generar model de User a través de devise:

```sh
rails generate devise User
```

Generar vistas de autenticación:

```sh
rails generate devise:views
```

En la migración generada agregar dentro del método create_table(:users) :

```ruby
t.string :first_name
t.string :last_name
t.string :username
```

Debajo de add_index :users, :reset_password_token, unique: true agregar:
```ruby
add_index :users, :username, unique: true
```

Generar migración:

```sh
rake db:migrate
```

Reiniciar el servidor.

Ahora debemos modificar las vistas generadas por devise y agregar los campos que nosotros definimos.

En app/views/devise/registrations/new.html.erb y app/views/devise/registrations/new.html.erb, debajo de la propiedad de email agregar:

```ruby
<%= f.input :username, required: true %>
<%= f.input :first_name, required: true %>
<%= f.input :last_name, required: true %>
```

Para permitir que nuestra aplicación acepte los parametros de usuario que agregamos debemos indicarle a devise cuales son los parámetros permitidos para un usuario. En app/controllers/application_controller.rb agregar:

```ruby
before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :username, :first_name, :last_name, :password, :password_confirm) }
    end
```

### Agregar validaciones de usuario.

En app/models/user.rb agregar:
```ruby
validates :first_name, :last_name, :username, :email, presence: true
validates :email, uniqueness: true
validates :username, uniqueness: { case_sensitive: false, message: "Username already taken" }
```

Para mejorar las rutas que nos proporciona devise agregamos en config/routes.rb lo siguiente:
```ruby
devise_scope :user do
  get 'register', to: 'devise/registrations#new', as: :register
  get 'login', to: 'devise/sessions#new', as: :login
  get 'logout', to: 'devise/sessions#destroy', as: :logout
end
```

Vamos a agregar un método a user.rb para que nos regrese el nombre completo:

```
def full_name
  first_name + " " + last_name
end
```

Para utilizar estos links en nuestra app agregamos las rutas a la navegación en app/views/layout/application.html.erb dentro de <ul class="nav navbar-nav">

```erb
<% if user_signed_in? %>
  <li><%= link_to current_user.full_name, edit_user_registration_path %></li>
  <li><%= link_to "Log Out", logout_path %></li>
<% else %>
  <li><%= link_to "Log In", login_path %></li>
  <li><%= link_to "Sign Up", register_path %></li>
<% end %>
```

### Asignar status a un usuario

Primero debemos generar una migración a la tabla statuses donde incluiamos el id del usuario.

```sh
rails generate migration add_user_id_to_statuses
```

En nunestra migración generada agregar dentro del método change:
```ruby
add_column :statuses, :user_id, :integer
```

Correr migración:

```
rake db:migrate
```

### Agregar relaciones entre usuario y status

En app/models/user.rb agregar:

```ruby
has_many :statuses
```

En app/models/status.rb agregar:

```ruby
belongs_to :user
```

### Filtros en controladores

Para asegurarnos que el usuario haya ingresado antes de crear, editar o borrar un tweet debemos agregar un filtro en app/controllers/statuses_controller.rb, utilizamos un filtro de autenticación que viene incluido en Devise.

```ruby
before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
```

### Agregar id de usuario al generar un tweet

En el controlador de statuses, dentro del método create agregar después de @status = Status.new(status_params)

```ruby
@status.user_id = current_user.id
```

Finalmente queremos mostrar el nombre del usuario al generar un tweet. Primero debemos eliminar los tweets que tenemos y generar nuevos tweets que pertenezcan a usuarios aleatorios.

Cerrar todo lo que esté conectado a nuestra BD y remplazar to lo que exitse en db/seeds.rb por:

```ruby
50.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  email = "example-#{n+1}@twitter.com"
  password = "password"
  username = "user#{n+1}"
  User.create!(first_name: first_name, last_name: last_name, username: username, email: email, password: password)
end

200.times do |n|
  content = Faker::Lorem.sentence(5)
  user_id = rand(1..50)
  Status.create!(content: content, user_id: user_id)
end
```

Por último debemos mostrar el nombre completo y username del usuario en el tweet.

En app/views/statuses/index.html.erb agregar:

```erb
<h5><%= status.user.full_name %> (@<%= status.user.username %>)</h5>
```
