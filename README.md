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
´´

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

Borrar el contenido de app/assets/stylesheets/scaffolds.css.scss