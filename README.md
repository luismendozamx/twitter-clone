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
      <ul class="nav navbar-nav">
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
  time = 1.year.ago..Time.now
  Status.create!(content: content, created_at: time)
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

En app/views/statuses/index.html.erb agregar:
```ruby
<%= will_paginate %>
```




