# Comandos a ejecutar


###Crear Aplicación

```
rails new twitter --database=postgresql --skip-test-unit
rake db:create
rake db:migrate
```

Agregar gems iniciales

```
gem 'bootstrap-sass', '~> 3.3.4'
gem 'simple_form'
```

Instalar gems
```
bundle install
```
Renombrar app/assets/stylesheets/application.css a app/assets/stylesheets/application.scss

Incluir en app/assets/stylesheets/application.css

```
@import "bootstrap-sprockets";
@import "bootstrap";
```
Incluir en app/assets/javascripts/application.js (Después de //= require jquery)

```
//= require bootstrap-sprockets
``

Crear generador de Simple Form
```
rails generate simple_form:install --bootstrap
```

Reiniciar el servidor para mostrar cambios.

###Crear el primer scaffold
```
rails generate scaffold status content:string
```

Generar migración en la base
```
rake db:migrate
```
###Mejorar nuestras vistas

Borrar el contenido de app/assets/stylesheets/scaffolds.css.scss

En app/views/layouts/application.html.erb cambiar el código dentro de <body> por:

```
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

```
<%= link_to 'Post New Tweet', new_status_path, class: "btn btn-default" %>

<h1>Twitter Feed</h1>

<% @statuses.each do |status| %>
<div class="col-sm-12 tweet">
  <td><%= status.content %></td>
  <div class="tweet-info">
    <%= link_to 'Show', status %> |
    <%= link_to 'Edit', edit_status_path(status) %> |
    <%= link_to 'Destroy', status, method: :delete, data: { confirm: 'Are you sure?' } %>
  </div>
</div>
<% end %>
```

