 #Best in Chrome, Safari - Firefox has some glitchy control issues.

$ ->

  mario = {
    element: $('.mario'),
    bottom: 40,
    left: 100
  }
  move_times = 10
  x_movement = null
  x_movement_on = false
  x_movement_dir = 0
  y_movement = null
  window_width = $(window).width()

  move_degree = (d) ->
    d * move_times

  move_mario = (x,y) ->

    new_x = mario.left + x
    new_x = 5 if new_x < 5

    new_y = mario.bottom + y
    new_y = 40 if new_y < 40

    mario.bottom = new_y
    mario.left = new_x
    mario.element.css
      bottom: mario.bottom
      left: mario.left

  start_movement = (x,y) ->

    # allow rapid change of direction
    if x != 0 && x_movement_on && x_movement_dir != x
      end_movement('x')

    if x != 0 && !x_movement_on
      mario.element.addClass('left') if x < 0
      mario.element.addClass('right') if x > 0
      x_movement_dir = x
      x_movement = setInterval ->
        move_mario move_degree(x), 0
      , 100
      x_movement_on = true
    else if y != 0
      y_movement = setInterval ->
        move_mario 0, move_degree(y)
      , 100

  end_movement = (axis) ->
    if axis == 'x'
      mario.element.removeClass('left')
      mario.element.removeClass('right')
      clearInterval(x_movement)
      x_movement_on = false
    else if axis == 'y'
      clearInterval(y_movement)

  $(window).keydown (e) ->
    if e.which ==  65 || e.which ==  37
      start_movement -4, 0
    else if e.which == 68 || e.which ==  39
      start_movement 4, 0
    else if e.which == 32
      move_mario 0, move_degree(20) if mario.bottom == 40 # must be on the ground to jump
  
  $(window).keyup (e) ->
    # only stop the animation if the current movement matches that of the button being released, if a change of direction had happened, we want to ignore this button release
    if e.which ==  65 || e.which ==  37
      end_movement 'x' unless x_movement_dir > 0 
    else if e.which == 68 || e.which ==  39
      end_movement 'x' unless x_movement_dir < 0

  setInterval () ->
    move_mario 0, move_degree(-2) unless mario.bottom == 40 # gravity
  , 40