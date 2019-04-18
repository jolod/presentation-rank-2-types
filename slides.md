% Notes on rank-2 types
% Why you need them and why you don't want them
% Johan Lodin @ Zimpler 2017-11-29

# Revised edition

The original presentation was meant to be experienced live and thus mostly devoid of comments, so in this version I have added some comments that captures the point of each slide.

# Intro

##

A simple data type:

```
newtype Point a = Point {x :: a, y :: a, z :: a}
```

* A *constructor* `Point` which takes ...
* ... a *record* with the fields `x`, `y`, `z`.
* Different from Haskell!

##

Pattern match constructor like Haskell:

```
unPoint (Point p) = p
```

Access record fields using dot syntax:

```
p.x
```

Put together for one-time field extraction:

```
\(Point p) -> p.x
```


# A simple function

##

```

getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)
```

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)
```

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)
```

  * Note: Type variables are explicit.

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)


getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety (Point p) = p.y
```

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)


getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety (Point p) = p.y
```

`gety` in `getyPair` is a seemingly simple refactoring/substitution.

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)

getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety (Point p) = p.y
```

But note that the type of `getyPair` is different from `getxPair`. There is no `b` in `getyPair`.

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)

getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety (Point p) = p.y


getzPair p1 p2 = Tuple (getz p1) (getz p2)


getz (Point p) = p.z
```

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)

getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety (Point p) = p.y

getzPair :: forall a b. Point a -> Point b -> Tuple a b
getzPair p1 p2 = Tuple (getz p1) (getz p2)

getz :: forall a. Point a -> a
getz (Point p) = p.z
```

However, the type of `getzPair` is the same as `getxPair`.

##

```
getxPair :: forall a b. Point a -> Point b -> Tuple a b
getxPair p1 p2 = Tuple ((\(Point p) -> p.x) p1) ((\(Point p) -> p.x) p2)

getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety (Point p) = p.y

getzPair :: forall a b. Point a -> Point b -> Tuple a b
getzPair p1 p2 = Tuple (getz p1) (getz p2)

getz :: forall a. Point a -> a
getz (Point p) = p.z
```

Let's also define `getx` and `gety`.

Now that we have the top-level getters, we don't want to repeat all the getPair functions, so we take the getter as an argument.

#

##

```

getPair get p1 p2 = Tuple (get p1) (get p2)
```

##

```
getPair :: forall a b. (a -> b) -> a -> a -> Tuple b b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

##

```
getPair :: forall a b. (a -> b) -> a -> a -> Tuple b b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

Yet another type!

  * Does not depend on Point at all,
  * but the two arguments must be the same.

What if you have points of different of types? You'd want the return value to be `Tuple a b`, not `Tuple b b`, as we had in `getxPair` and `getzPair`.

# Revisiting `getyPair` and `getzPair`

##

##

```

getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where

  gety (Point p) = p.y


getzPair p1 p2 = Tuple (getz p1) (getz p2)


getz (Point p) = p.z
```

##

```
getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where

  gety (Point p) = p.y

getzPair :: forall a b. Point a -> Point b -> Tuple a b
getzPair p1 p2 = Tuple (getz p1) (getz p2)


getz (Point p) = p.z
```

##

```
getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety :: Point a -> a
  gety (Point p) = p.y

getzPair :: forall a b. Point a -> Point b -> Tuple a b
getzPair p1 p2 = Tuple (getz p1) (getz p2)

getz :: forall a. Point a -> a
getz (Point p) = p.z
```
##

```
getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety :: Point a -> a
  gety (Point p) = p.y

getzPair :: forall a b. Point a -> Point b -> Tuple a b
getzPair p1 p2 = Tuple (getz p1) (getz p2)

getz :: forall a. Point a -> a           -- There's the difference: forall!
getz (Point p) = p.z
```

##

```
getyPair :: forall a. Point a -> Point a -> Tuple a a
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety :: Point a -> a
  gety (Point p) = p.y
```

The type of `gety` in `gety p1` must be `Point a -> a`. If `p2` was of type `Point b` then the type of `gety` in `gety p2` would have to be `Point b -> b`. So `gety` must be both `Point a -> a` and `Point b -> b`, which implies that `a` and `b` are the same.

##

```
getyPair :: forall a b. Point a -> Point b -> Tuple a b
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety :: forall c. Point c -> c -- Annotated.
  gety (Point p) = p.y
```

##

```
getyPair :: forall a b. Point a -> Point b -> Tuple a b
getyPair p1 p2 = Tuple (gety p1) (gety p2)
  where
  gety :: forall c. Point c -> c -- Annotated.
  gety (Point p) = p.y
```

By introducing a new type variable in `gety` we can use any type of `Point`, so `gety` can in fact be using `a` in one expression and `b` in another without unifying `a` and `b`.

  * In `(gety p1)` we have `gety :: Point a -> a`.
  * In `(gety p2)` we have `gety :: Point b -> b`.

# Revisiting `getPair`

##

```


getPair :: forall a b. (a -> b) -> a -> a -> Tuple b b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

##

```


getPair :: forall a b. (                a -> b) ->       a ->       a -> Tuple b b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

##

```
--                                           Spot the change ------\----------\
--                                                                  v          v
getPair :: forall a b. (forall c. Point c -> c) -> Point a -> Point b -> Tuple a b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

Rank-2 type!

##

```


getPair :: forall a b. (forall c. Point c -> c) -> Point a -> Point b -> Tuple a b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

Problem solved!

# Higher order quantification

##

```
getPair :: forall   a b. (forall c. Point c -> c) -> Point a -> Point b -> Tuple a b
getPair get p1 p2 = Tuple (get p1) (get p2)
```

Does not depend on `Point`, really.

##

```
getPair :: forall t a b. (forall c.     t c -> c) ->     t a ->     t b -> Tuple a b
getPair get r1 r2 = Tuple (get r1) (get r2)
```

Replace `Point` with type variable `t`.

##

```
getPair :: forall t a b. (forall c. t c -> c) -> t a -> t b -> Tuple a b
getPair get r1 r2 = Tuple (get r1) (get r2)
```

Replace `Point` with type variable `t`.

# Full example

```
newtype Point a = Point {x :: a, y :: a}
getx (Point p) = p.x
gety (Point p) = p.y

getPair :: forall t a b. (forall c. t c -> c) -> t a -> t b -> Tuple a b
getPair get r1 r2 = Tuple (get r1) (get r2)

pointValues = Point {x: 3, y: 4}
pointLabels = Point {x: "x", y: "y"}

xPair = getPair getx pointLabels pointValues
yPair = getPair gety pointLabels pointValues

main :: Eff (dom :: DOM) Unit
main = render $ foldMap (\s -> p (text s))
  [ show xPair
  , show yPair ]
```

```
(Tuple "x" 3)

(Tuple "y" 4)
```

# Applicatives

##

**Definition**

A `Functor` that also implements

```
apply :: forall f a b. f (a -> b) -> f a -> f b
```

(Also, `pure`.)

##

```
fmap  :: forall f a b. (a -> b) -> f a -> f b
apply :: forall f a b. f (a -> b) -> f a -> f b
bind' :: forall f a b. (a -> f b) -> f a -> f b
```

##

```
fmap  :: forall f a b.   (a -> b) -> (f a -> f b)
apply :: forall f a b. f (a -> b) -> (f a -> f b)
bind' :: forall f a b. (a -> f b) -> (f a -> f b)
```

##

```
fmap  :: forall f a b.   (a -> b) -> (f a -> f b)
apply :: forall f a b. f (a -> b) -> (f a -> f b)
bind' :: forall f a b. (a -> f b) -> (f a -> f b)
```

What happens when you do partial application in `fmap`?

```
(a -> b        ) -> f a -> f b
(a -> (b' -> c)) -> f a -> f (b' -> c)
```

You get a value that you can give to `apply`!

Hence the name, applicative functor.

##

```
newtype Point a = Point {x :: a, y :: a, z :: a}

instance functorPoint :: Functor Point where
  map f (Point p) = Point
    { x: f p.x
    , y: f p.y 
    , z: f p.z }

instance applyPoint :: Apply Point where
  apply (Point f) (Point p) = Point
    { x: f.x p.x
    , y: f.y p.y 
    , z: f.z p.z }

point x y z = Point {x, y, z}
```

```
apply
  (point inc inc id)
  (point 3 4 -1)

point inc inc id <*> point 3 4 -1 -- Using infix notation.
```

##

```
newtype Point a = Point {x :: a, y :: a, z :: a}

instance functorPoint :: Functor Point where
  map f (Point p) = Point
    { x: f p.x
    , y: f p.y 
    , z: f p.z }

instance applyPoint :: Apply Point where
  apply (Point f) (Point p) = Point
    { x: f.x p.x
    , y: f.y p.y 
    , z: f.z p.z }

point x y z = Point {x, y, z}
```

```
apply
  (fmap
    (point (+) (+) (-))
    (point 3 4 5)
  (point 1 1 2)

point (+) (+) (-) <$> point 3 4 5 <*> point 1 1 2 -- Infix notation.
(point (+) (+) (-) <$> point 3 4 5) <*> point 1 1 2 -- Explicit bracketing.
```


# Digression

##

```
fmap  :: forall f a b.   (a -> b) -> (f a -> f b)
apply :: forall f a b. f (a -> b) -> (f a -> f b)
bind' :: forall f a b. (a -> f b) -> (f a -> f b)
```

What the triple above does is that it takes functions where the `f` is at different places (or absent), and turn them into functions of the same type. That in turn means that they can be composed.

##

I dub 2017 the category theory year of functional programming--if you look at non-academic conferences and in the blogosphere category theory is mentioned everywhere. Since functor is a concept from category theory, I think it is worth pointing out the categorical aspects.

##

What `fmap` does is that it maps one arrow (which in Haskell is a function) to another arrow (which is a function) according to some rules. Importantly, it's an unary function. This is contrasted by the view that `map` works on the contents of an object through a function--a view that is particularly encouraged in object oriented languages where `map` is typically a method on an object.

A mathematical function also maps objects from one category to another. When using `Functor` the objects are types and the category is the category of all the types in the language.

##

The categorical arrows are the ones in the parentheses, and the middle arrow is the map that the functor defines.

```
                               vv <---------------- the functor map
fmap :: forall f a b. (a -> b) -> (f a -> f b)
                         ^^            ^^ <-------- the target arrow
                         ^^ <---------------------- the source arrow
```

The other map, is the type constructor, which maps a type to another type (like `Int` to `List Int`) and has the kind `* -> *`.

# The applicative approach

##

```
newtype Point a = Point {x :: a, y :: a, z :: a}

instance functorPoint :: Functor Point where
  map f (Point p) = Point
    { x: f p.x
    , y: f p.y 
    , z: f p.z }

instance applyPoint :: Apply Point where
  apply (Point f) (Point p) = Point
    { x: f.x p.x
    , y: f.y p.y 
    , z: f.z p.z }
```

##

```
pointValues = Point {x: 3, y: 4, z: 5}
pointLabels = Point {x: "x", y: "y", z: "z"}

xPair = getx $ Tuple <$> pointLabels <*> pointValues
yPair = gety $ Tuple <$> pointLabels <*> pointValues
```

Same result as before. `getPair` is not really needed anymore.

```
getPair :: forall f a b c. Apply f => (f (Tuple a b) -> c) -> f a -> f b -> c
getPair get p1 p2 = get $ Tuple <$> p1 <*> p2
```

`getPair` can in fact take a non-getter as the get function:

```
getxy (Point p) = Tuple p.x p.y
bothPairs = getPair getxy pointLabels pointValues -- (Tuple (Tuple "x" 3) (Tuple "y" 4))
```

The type might seem very general, not even returning a tuple. This is because you effectively compose `f a -> f b -> f (Tuple a b)` and `f (Tuple a b) -> c`.

# Summary

So, in summary, we can have at least these three different types for our getPair function:

```
getPair :: forall a b. (a -> b) -> a -> a -> Tuple b b
getPair :: forall t a b. (forall c. t c -> c) -> t a -> t b -> Tuple a b
getPair :: forall f a b c. Apply f => (f (Tuple a b) -> c) -> f a -> f b -> c
```

  * In the first, the points need to be of the same type.
  * In the second, it must be placed in a wrapper type (`Point`), and you must write the type yourself, but it is "non-invasive".
  * In the third, `Point` must implement `Apply`, but the type is inferred and you can use a more general function than a getter, like getting both x and y.

# Summary (cont.)

The downside with the last, using `Apply`, is that you do the computations for all fields and then just extract one. In a lazy language that would not be a problem, but PureScript is strict, so if you have a really large record and a heavy computation then you will potentitally waste a lot of time doing work you will throw away.

In practice, I would implement the applicative when possible, if only for type inference reasons.
