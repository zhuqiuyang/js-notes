### 1. Introduction

#### 1.1 About this tutorial

#### 1.2 So what's Haskell?

* 纯函数式
* lazy
* 静态类型(但可以不显式声明)
* 精简

#### 1.3 What you need to dive in

```sh
ghci
:quit
```

### 2. Starting Out

#### 2.1 Ready, set, go!

* GHC
* prefix 函数转成 infix

```hs
div 92 10
-- 等于
92 `div` 10
```

`spaces` 用于表示函数调用

#### 2.2 Baby's first functions

* `else` 分支是必不可少的

```hs
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1  
```

`'` 表示严格函数(not lazy)

* 函数首字母不能大写
* 无参函数, 可视为`definition`(如下)

```hs
conano'Brien = "xxx"
```

#### 2.3 An intro to lists

* 元素类型 must 一致 (homogenous)
* `++` put two list together
* index

```hs
ghci> "Steve Buscemi" !! 6  
'B'  
```

```hs
[1,2]
```

#### 2.4 Texas ranges

* 长度上限
* 步长

```hs
[1..100]
```

#### 2.5 I'm a list comprehension

```hs
ghci> [x*2 | x <- [1..10], x*2 >= 12]  
[12,14,16,18,20]  
```

通过`predicate`对`list`进行筛选 called **`filtering`**

* serveral predicates:

```hs
ghci> [ x | x <- [10..20], x /= 13, x /= 15, x /= 19]  
[10,11,12,14,16,17,18,20]
```

#### 2.6Tuples

两个元素的`Tuple`称作`pair`

### 3. Types and Typeclasses

#### 3.1 Believe the type

`:t` 用于检测数据类型

```hs
ghci> :t 'a'  
'a' :: Char
ghci> :t True  
True :: Bool
```

#### 3.2 Type variables

```hs
ghci> :t head  
head :: [a] -> a
```

代表`Type`必须大写, `a`此处表示 `type variable`
`a`可以是任何类型, 类似其他语言中`generics`

## 多态

**Functions** that have `type variables` are called **polymorphic functions**.

#### 3.3 Typeclasses 101

```hs
ghci> :t (==)  
(==) :: (Eq a) => a -> a -> Bool
```

`=>`前称为`class constraint`

A `typeclass` is a sort of `interface` that defines some behavior.

* Eq, Ord, Show, Read ...

#### Type annotation (类型描述)

在`expression`end 处添加`::`, 然后指定类型

```hs
ghci> read "5" :: Int  
5
```

* 所有 numbers 都是`polymorphic constant`(多态常量)

### 4. Syntax in Functions

#### 4.1 Pattern matching

定义: `Pattern matching`由指定的`patterns`组成, 对应数据会**check**是否与`pattern`一致, 或可根据`pattern`进行**deconstruct**.

* last should catch all !

  > Note that (x:[]) and (x:y:[]) could be rewriten as [x] and [x,y] (because its syntatic sugar, we don't need the parentheses). We can't rewrite (x:y:\_) with square brackets because it matches any list of length 2 or more.

* 递归定义:

```hs
sum' :: (Num a) => [a] -> a  
sum' [] = 0  
sum' (x:xs) = x + sum' xs  
```

* `xs@(x:y:ys)`, `@`前`xs`代表匹配的整体

#### 4.2 Guards, guards!

* 见 4.3, 以`|`分隔
* `otherwise` catch all.
  #### 4.3 Where!?

```hs
bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height  
    | bmi <= skinny = "You're underweight, you emo, you!"  
    | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | bmi <= fat    = "You're fat! Lose some weight, fatty!"  
    | otherwise     = "You're a whale, congratulations!"  
    where bmi = weight / height ^ 2  
          skinny = 18.5  
          normal = 25.0  
          fat = 30.0
```

#### 4.4 Let it be

`let` 与 `where` 对比

* `where`在后定义
* `where` cross `guard`, `let`not.
* `let...in...` 是 expression

#### 4.5 Case expressions

`pattern match` in expression 是`case expressions`的语法糖. (\*)

### 5. Recursion

#### 5.1 Hello recursion!

* `Recursion`是一种定义`functions`的方式, 其会在内部调用自身.
* `edge condition`(基础条件): non-recursively, likely `F(0), F(1)`在 Fibonacci.

#### 5.2 Maximum awesome

rewrite `maximum`: (elegant)

```hs
maximum' :: (Ord a) => [a] -> a  
maximum' [] = error "maximum of empty list"  
maximum' [x] = x  
maximum' (x:xs) = max x (maximum' xs)  
```

#### 5.3 A few more recursive functions (举例)

> `replicate`, `take` , `repeat`, `elem` ...

#### 5.4 Quick, sort!

Neat(!)

```hs
quicksort :: (Ord a) => [a] -> [a]  
quicksort [] = []  
quicksort (x:xs) =
    let smallerSorted = quicksort [a | a <- xs, a <= x]  
        biggerSorted = quicksort [a | a <- xs, a > x]  
    in  smallerSorted ++ [x] ++ biggerSorted
```

#### 5.5 Thinking recursively

### 6. High Order Function

Higher order functions 凝聚了很多 Haskell 的开发经验. 它证明, 如果你想 `define computations by defining what stuff is` instead of `defining steps that change some state and maybe looping them`, higher order functions 是不可缺少的.

> 如果更 declative, higher order functions 是必不可少的.

## 6.1 Curried functions (重要)

默认所有 Function 都是单参的

* 所有多参函数, 都是**curried functions**
* call a function 少于它所需要的参数, 我们将得到**partial applied**function.

#### 6.2 Some higher-orderism is in order

`->` 默认是`right accociation`

> Note: 为了简便, 称`a -> a -> a`为双参函数

#### 6.3 Maps and filters

`map`和`filter`是一对搭档, 在 FP 中使用极广.

* 使用`map`解决问题(更易读), 也可用`list comprehension`替代.
  > `map (+3) [1,5,3,1,6]` same as `[x+3 | x <- [1,5,3,1,6]]`
* `takeWhile` 截取 List 直到`predicate`不满足
  > `takeWhile (/=' ') "elephants know how to party"` and it would return `"elephants"`
  #### 6.4 Lambdas
  `lambda`是普通函数, 一般使用 only once.

有些场景, partial applied 更易读

* `map (+x) [1..]` same as `map (\x -> x + 3) [1..]`

#### 6.5 Only folds and horses

* `folds`遍历 list, 返回 a signle value(acc)
  * 次序: `foldl`, `foldr`
  * `foldr1`: 使用第一个元素, 作为`acc`初始值
    > `folds`和`maps`, `filters`同为最常用的函数
* `scan` 返回`acc`的状态 list

#### 6.6 Function application with $

`$`和空格, 同为函数调用的两种方式

* `空格`是左结合
* `$`是右结合

```hs
sqrt (3 + 4 + 9)
-- same as
sqrt $ 3 + 4 + 9
```

`$` has the lowest precedence of any operator.

#### 6.7 Function composition

`.` 接收两个函数, 返回一个新的函数.

* point free 风格

### 7.Modules

#### 7.1 Loading modules

* `import Data.List`: 则`Data.List`exports 全局可用.
* `import Data.List (nub, sort)`: 导出指定
* `import Data.List hiding (nub)`
* `import qualified Data.Map as M`, 使用时则`M.filter`.

#### 7.6 Making our own modules

```hs
module Shapes
( Point(..)  
, Shape(..)  
, surface  
, nudge  
, baseCircle  
, baseRect  
) where
```

通过`Shape(..)`(8.1 例子), `Shape`的所有 value constructor 都会被导出

### 8. Making Our Own Types and Typeclasses

#### 8.1 Algebraic data types intro

* 通过`data`来自定义 data type
* `value constructors` 是函数, 接收一些列参数, 返回相应的 value of some type.

#### 8.2 Record Syntax

better way than `data Person = Person String String Int Float String String deriving (Show)`

```hs
data Person = Person { firstName :: String  
                     , lastName :: String  
                     , age :: Int  
                     , height :: Float  
                     , phoneNumber :: String  
                     , flavor :: String  
                     } deriving (Show)
```

Record Syntax 优势:

* 自动 create 取值函数`firstName::Person -> String`
* when `derive`from `Show`, 展示出具体字段名

  ```hs
  data Car = Car String String Int deriving (Show)  

  ghci> Car "Ford" "Mustang" 1967
  Car "Ford" "Mustang" 1967
  --
  data Car = Car {company :: String, model :: String, year :: Int} deriving (Show)  

  ghci> Car {company="Ford", model="Mustang", year=1967}
  Car {company = "Ford", model = "Mustang", year = 1967}  
  ```

#### 8.3 Type parameters

`data Maybe a = Nothing | Just a`, 由于`a`是一个`type parameter`, 所以我们称`Maybe`是`type constructor`.

* `Just 'a'` 的 type 为`Maybe Char`
* empty list(`[]`)的 type 为`[a]`
  > 所以我们可以进行`[1,2,3] ++ []`和`["ha","ha","ha"] ++ []`操作.

`Type paramter`适用于`List`, `Maybe`这类不关心元素具体类型的 type.

> 不要在 data declaration 中添加 typeclass 限制, 放在函数的 type declaration 中.

`data Vector a = Vector a a a deriving (Show)`:

* `=`前的`Vector`是 **`type constructor`**
* `=`后的`Vector`是 **`value constructor`**

#### 8.4 Derived instances

```hs
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
           deriving (Eq, Ord, Show, Read, Bounded, Enum)

ghci> Wednesday  
Wednesday  
ghci> show Wednesday  
"Wednesday"  
ghci> read "Saturday" :: Day  
Saturday
ghci> Saturday > Friday  
True  
ghci> Monday `compare` Wednesday  
LT  
```

#### 8.5 Type synonyms

**type synonyms**: `String`和`[Char]`是相等且能 interchangable(可交换的).

```hs
type String = [Char]
```

#### Type synonyms can also be parameterized (参数化)

```hs
type AssocList k v = [(k,v)]
```

### concrete type

`AssocList`: is a `type constructor` + two `types` => **`concrete type`**(like `AssocList Int String`, **fully applied types**, `type constructor`完整调用).

> `data Int = ...`, 无参的`type constructor`, 本身就是 concrete type.

### 自己理解-与*data*定义的`type constructor`的区别

* `data`的`type constructor`主要定义`type`的具体内部实现
* `type`主要定义别名.

#### Either

`data Either a b = Left a | Right b deriving (Eq, Ord, Read, Show)`

* Maybe 不能展示 failure 的信息, Either 可以.

#### 8.6 Recursive data structures

algebratic data types 实现 List:

```hs
data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord)
```

当我们把 function 定义成操作符, 需要使用`fixity声明`

```hs
-- 自定义一个操作符 :-:
infixr 5 :-:
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)
```

`*`的 fixity 是`infixl 7 *`.(数值越高优先级越高, `infixl`代表中缀, 左结合)

#### 8.7 Typeclasses 102

```hs
class Eq a where  
    (==) :: a -> a -> Bool  
    (/=) :: a -> a -> Bool  
    x == y = not (x /= y)  
    x /= y = not (x == y)
```

`a`是一个 concrete type, 因为函数只接收 concrete type. (举例: 函数的 type 不能为`a -> Maybe`, 但是可以是`a -> Maybe a`,或`Maybe Int -> Maybe String`)

```hs
instance Eq TrafficLight where  
    Red == Red = True  
    Green == Green = True  
    Yellow == Yellow = True  
    _ == _ = False  
```

`class`关键字用于定义一个新的`typeclass`, `instance`is for making our `types instances` of `typeclasses`.
`instance Eq TrafficLight where`.我们用`actual type`替换了`a`

##### subclass

```hs
class (Eq a) => Num a where  
   ...
```

#### 8.8 A yes-no typeclass

#### 8.9 The Functor typeclass

```hs
class Functor f where  
    fmap :: (a -> b) -> f a -> f b  

instance Functor Maybe where  
    fmap f (Just x) = Just (f x)  
    fmap f Nothing = Nothing  
```

`f`是一个`type constructor`,可以使`Maybe`, `Either a`

#### 8.10 Kinds and some type-foo

* 未读

`type constructor`和`function`有很多共同之处, 但两者是完全不同的东西.

### 9. Input and Output

Haskell 对`pure`和 `impure`做了分离.

#### 9.1 Hello, world!

```hs
ghci> :t putStrLn "hello, world"  
putStrLn "hello, world" :: IO ()
```

`IO Action`定义: 是指当执行带有`side effect`的`action`(reading from the input or printing stuff to the screen)时, 会返回一个`result.`(上述返回的时`()`, 空调 tuple)

```hs
main = do  
    putStrLn "Hello, what's your name?"  
    name <- getLine  
    putStrLn ("Hey " ++ name ++ ", you rock!")
```

* `main`的 signature 是`mian :: IO something` (something 是`concrete type`)
* `do`把多个`IO`合并成一个
* `<-` 从`IO`结果中获取数据
* `getLine`Action 是**impure**的, 因为执行多次, 并不能确保结果一致

##### 运行

* `ghc --make helloworld`, `./helloworld`
  `runhaskell`in CLI, 可以运行`.hs`文件

#### 9.2 Files and streams

* `getChar`: reads a single character from the terminal
* `getLine`: reads a single line from the terminal
* `getContents`: reads everything from the standard input , 直到遇到`end-of-file`character

```hs
-- capslocker.hs
import Data.Char  

main = do  
    contents <- getContents  
    putStr (map toUpper contents)  
```

* 当`getContents` is bound to `contents`, 在内存中它将不是一个`string`, 而是一个 promise 最终会产生`string`
* 当`map toUpper over contents`, 仍是一个 promise `map that function over the eventual contents`
* 直到遇到`putStr`:
  * it 对前一个 promise: "Hey, I need a capslocked line!"
  * 然后再请求`contents`: "Hey, how about actually getting a line from the terminal?"

lines & unlines:

```hs
> lines "a\nb\n"
["a","b"]
> unlines ["a", "b"]
"a\nb\n"
```

##### interact

`interact` 接受一个函数作为参数(`String -> String`) , 并返回一个`I/O action` that will take some input, 返回函数执行过的结果, 打印显示.
(study end)

### 10. Functionally Solving Problems

#### 10.1 Reverse Polish notation calculator

`RPN`: 逆波兰表达式

#### 10.2 Heathrow to London

#### 11. Functors, Applicative Functors and Monoids

#### 11.1 Functors redux

**computation context**比喻`Functor`, 更确切

Functor 的 instance, like `[]`, `Maybe`, `Either a` and a `Tree`.
这一节, 我们接触另两种 functor, namely `IO` and `(->) r`.

1. IO

```hs
instance Functor IO where  
    fmap f action = do  
        result <- action  
        return (f result)
```

2. (->) r
   `r -> a` 的 function type 可重写为`(->) r a`, 就如同`2 + 3` as `(+) 2 3`
   不同的是`(->)`是一个`type constructor`, 接受两个`type parameters`作为参数, 就像`Either`.

`fmap` over function, 本质是函数的组合

```hs
instance Functor ((->) r) where
    fmap = (.)
```

Lift:
`fmap`接收一个函数, 返回一个操作`Functor`的函数.

Functor Law:

1. 同一律: `fmap id = id`
2. 交换律: `fmap (f . g) F = fmap f (fmap g F)`

#### 11.2 Applicative functors

`Applicative` typeclass. 位于`Control.Applicative` module, 其定义了两个 method: `pure` 和 `<*>`.

```hs
class (Functor f) => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b
```

#### !!!

* `pure`: `f`在这里表示`applicative functor instance`(type construcor)
* `<*>`: 从一个 Functor 中提取 Lift 的函数. 对比`fmap :: (a -> b) -> f a -> f b`

`Applicative` instance implementation for `Maybe`:

```hs
instance Applicative Maybe where  
    pure = Just
    Nothing <*> _ = Nothing
    (Just f) <*> something = fmap f something
```

`Applicative functors` 允许用一个 function 来操作多个 functor:

```hs
ghci> pure (+) <*> Just 3 <*> Just 5  
Just 8
```

* `<*>`是左结合的
* `pure f <*> x` 等于 `fmap f x`

##### `fmap`的中缀操作符`<$>`: !!

```hs
(<$>) :: (Functor f) => (a -> b) -> f a -> f b  
f <$> x = fmap f x  
```

Applicative Functor Instance:

* Maybe
* List
* IO
* (-> r)

  * call `<*>` with 两个 ap, 返回一个 ap; with 两个 function, 返回一个 function:

  ```hs
  ghci> :t (+) <$> (+3) <*> (*100)  
  (+) <$> (+3) <*> (*100) :: (Num a) => a -> a
  -- 返回一个函数 use `+` on the result of `+3` 和 `*100`
  ```

  解释: `k <$> f <*> g` 返回一个函数, call `f` with 最终结果 from `f` 和 `g`

  > 可以把函数想象成 box(that contain 最终的结果),

* ZipList
  * `[(+3),(*2)] <*> [1,2]` 会返回`[4,5,2,4]`
  * 而`ZipList [(+3),(*2)] <*> ZipList [1,2]`会返回`[4, 4]`(`[1 + 3, 2 * 2]`)
  * `(,,)`函数 same as `\x y z -> (x,y,z)`
    > 第六章 有`zipWith`定义

#### 11.3 The newtype keyword

到现在为止, 我们学习了:

* make algebraic data types by using the `data` keyword.
* 如何给 existing types synonyms with the `type` keyword.
* 这一章, 学习如何 make new types out of existing data types by using the `newtype` keyword and why we'd want to do that in the first place.

##### 背景

> 待解决的问题: 为了让函数一一匹配, 引入了`ZipList`, 如何通过`newtype`实现?

```hs
ghci> [(+1),(*100),(*5)] <*> [1,2,3]  
[2,3,4,100,200,300,5,10,15]

ghci> getZipList $ ZipList [(+1),(*100),(*5)] <*> ZipList [1,2,3]  
[2,200,15]  
```

1. 通过`data`来实现

```hs
data ZipList a = ZipList { getZipList :: [a] }
```

> `newtype`主要应用于 wrap 已有的`type`, 制造新的`type`:

2. 通过`newtype`来实现:

```hs
newtype ZipList a = ZipList { getZipList :: [a] }
```

为什么用`newtype`:

* `newtype` 内部实现更快, hs 不做多余的`wrap`和`unwrap`

为什么不使用`newtype`替代`data`:

* 限制: 使用`newtype`, 只允许 `one constructor` with `one field`

举例:

```hs
newtype CharList = CharList { getCharList :: [Char] } deriving (Eq, Show)

ghci> CharList "this will be shown!"  
CharList {getCharList = "this will be shown!"}

CharList :: [Char] -> CharList

getCharList :: CharList -> [Char]
```

`CharList` 和`getCharList`是两个相反的过程, 可以认为是对`[Char]`的 wrap 和 unwrap.

##### Using newtype to make type class instances

以前我们实现`Maybe`只需要这样:

```hs
instance Functor Maybe where
```

如果我们想 make 一个`tuple` 作为`Functor`的 instance, 实现`fmap (+3) (1,1)`(只作用于第一个 component)返回`(4,1)`, 如何做呢?

* 第二个`type parameter`, 是 tuple 的第一个 component:

```hs
newtype Pair b a = Pair { getPair :: (a,b) }
```

然后`fmap`只作用于 1st component:

```hs
instance Functor (Pair c) where
    fmap f (Pair (x,y)) = Pair (f x, y)
```

效果:

```hs
ghci> getPair $ fmap (*100) (Pair (2,3))  
(200,3)
```

##### On newtype laziness

##### type vs. newtype vs. data

* If you just want your type signatures to look cleaner and be more descriptive, you probably want type synonyms.
* If you want to take an existing type and wrap it in a new type in order to make it an instance of a type class, chances are you're looking for a newtype.
* And if you want to make something completely new, odds are good that you're looking for the data keyword.

#### 11.4 Monoids

定义: Monoid 是一个二元函数, 并且具有`identity value`, 例如:

* `++` 的 `[]`
* `*` 的 `1` (任何数\* 1 等于其自身)

```hs
class Monoid m where
    mempty :: m
    mappend :: m -> m -> m
    mconcat :: [m] -> m
    mconcat = foldr mappend mempty
```

`mconcat`是一个一个 List 的 monoid 从右 `reduce`成一个 single value, 执行`mappend`

##### List 是 monoid

```hs
instance Monoid [a] where
    mempty = []
    mappend = (++)
```

`Monoid`require 一个`concrete type`, 因此用`[a]`(其表示 a List 可以 hold 任何 type)

##### product & sum

* `+`的 identity value 是`0`

##### Any & All(或, 与) Bool

* `||` id value `False`
* `&&` id value `True`

##### The Ording Monoid

`LT`, `EQ` ,`GT` means : less , equal, greater

##### Maybe the monoid

`Maybe a` 是 monoid, 当其 type parameter `a` 是一个 monoid. `Nothing`是 identity.

```hs
instance Monoid a => Monoid (Maybe a) where
    mempty = Nothing
    Nothing `mappend` m = m
    m `mappend` Nothing = m
    Just m1 `mappend` Just m2 = Just (m1 `mappend` m2)
```

#### Using monoids to fold data structures (用途!)

使用`folds` 操作各种 `data structures`, `Foldable` type class 需要引入.

```hs
import qualified Foldable as F
```

(读到 Tree 停止)

### 12. A Fistful of Monads (一把 Monads)

#### 12.1 Getting our feet wet with Maybe

`Monad`: 就是支持`>>=`(bind)的 `ap`. (ap 的升级版)

#### 12.2 The Monad type class

```hs
class Monad m where  
    return :: a -> m a

    (>>=) :: m a -> (a -> m b) -> m b

    (>>) :: m a -> m b -> m b
    x >> y = x >>= \_ -> y

    fail :: String -> m a
    fail msg = error msg
```

> `return` 类似 Promise.resolve
>
> `>>=` 类似 Promise.then
>
> `fail` 类似 Promise.reject

Haskell 中`return` 是一个普通函数, 把 value 放入一个 context 中. 并无其他 language 中`end`的含义.

#### 12.3 Walk the line

> 背景: 走钢丝, 平衡杆上停的 bird. 通过 Monad 来计算.

pipe?:

```hs
x -: f = f x

ghci> (0,0) -: landLeft 1 -: landRight 4 -: landLeft (-1) -: landRight (-2)
(0,2)
```

问题: 第三个执行完应当 `fail`
改进: 使用 monadic application (>>=) instead of normal application:

```hs
ghci> return (0,0) >>= landLeft 1 >>= landRight 4 >>= landLeft (-1) >>= landRight (-2)  
Nothing
```

> 个人理解: Monad pipe

### 注意: 平衡杆的例子中, `Maybe`若只是`ap`, 无法实现上述效果.

> 因为 ap 做不到在 function apply 之后, 继续更多的 interaction,

#### >> `Anythig >> Nothing` : 表示一定返回`Nothing`到下一轮

> 用于替代函数(which 忽略输入, 返回预定的 monadic value)

eg (踩到香蕉皮一定 fail):

```hs
banana :: Pole -> Maybe Pole  
banana _ = Nothing

ghci> return (0,0) >>= landLeft 1 >>= banana >>= landRight 1  
Nothing

-- 使用>>

ghci> return (0,0) >>= landLeft 1 >> Nothing >>= landRight 1
Nothing
```

书上有对比, 不使用`Maybe`的复杂实现.

a neat chain of monadic applications with `>>=`的一个典型例子就是: 利用`Maybe`进行持续计算(which 会有失败的可能.)

#### 12.4 do notation

> 是 chaining monadic value 的语法糖, 就像`async/await`之于`Promise`.
>
> 把 glue 在一起的`>>=`, 用`do <-`分开

```hs
foo :: Maybe String  
foo = Just 3   >>= (\x ->
      Just "!" >>= (\y ->
      Just (show x ++ y)))
--

foo :: Maybe String
foo = do
    x <- Just 3
    y <- Just "!"
    Just (show x ++ y)
```

In `do` 表达式中:

* 每一个都是 monadic type
* 一个是`Nothing`, `do`就返回`Nothing`
* 运行对 `monadic value`绑定 name, 并可以进行**pattern matching**

pattern match 失败, 不会导致 program crash:

```hs
-- 忽略error 信息, 返回Nothing
fail _ = Nothing

-- 则 pattern match失败, whole result为`Nothing`
wopwop :: Maybe Char  
wopwop = do
    (x:xs) <- Just ""
    return x
```

#### 12.5 The list monad

我们刚学习了`Maybe` with`>>=`
这一节, 看一下如何从 `monadic` 视角看待`lists`, 并把 non-determinism 引入我们的 code.

list monad:

```hs
instance Monad [] where
    return x = [x]
    xs >>= f = concat (map f xs)
    fail _ = []
```

Ch 7.Module 提到`concat`:

> 把元素为 list 的 list, flatten 成 list.

```hs
ghci> concat ["foo","bar","car"]  
"foobarcar"  
```

多个 list 链式调用:

```hs
ghci> [1,2] >>= \n -> ['a','b'] >>= \ch -> return (n,ch)  
[(1,'a'),(1,'b'),(2,'a'),(2,'b')]  
```

`[1,2]` gets bound to `n` and `['a','b']` gets bound to `ch`

> 强大: 之前通过`>>=`提取的 value, 后续 `>>=`的函数中也可以访问.(个人理解: js Promise.then 做不到, 需要 async)

类似`do`如下:

```hs
listOfTuples :: [(Int,Char)]  
listOfTuples = do
    n <- [1,2]
    ch <- ['a','b']
    return (n,ch)
```

#### `list comprehensions` use lists as monads 的**语法糖**

```hs
ghci> [ (n,ch) | n <- [1,2], ch <- ['a','b'] ]
[(1,'a'),(1,'b'),(2,'a'),(2,'b')]
```

因为 non-deterministic, 所以需要`filter`?

```hs
sevensOnly :: [Int]  
sevensOnly = do  
    x <- [1..50]  
    guard ('7' `elem` show x)  
    return x
--

ghci> [ x | x <- [1..50], '7' `elem` show x ]  
[7,17,27,37,47]  
```

`filtering` in list comprehensions is the same as using `guard`.

#### 12.6 A knight's quest(八皇后问题)

#### 12.7 Monad laws

#### 12.7.1 Left identity

`return x >>= f` is the same damn thing as `f x`

#### 12.7.2 Right identity

`m >>= return` is no different than just `m`

##### <=< (组合 monadic functions)

> just like `.`组合普通函数

```hs
(<=<) :: (Monad m) => (b -> m c) -> (a -> m b) -> (a -> m c)
f <=< g = (\x -> g x >>= f)
```

#### 12.7.3 Associate

`(m >>= f) >>= g` is just like doing `m >>= (\x -> f x >>= g)`

### 13. 更多的 Monads

* Writer
* Reader
* state
* Error error on the wall

#### 13.5 Some useful monadic functions

* liftM (操作 Monad 的`fmap`)

* join (剥开外层 Monad)

* filterM

* foldM

#### 13.6 Making monads

### 14. Zipper

背景: 由于引用透明(same input -> same output), 也有不如 impure 方便之处, 比如:

* 修改一个 tree 的节点, 需要继续 root 节点到其的路径, 然后返回一个新的 tree.

这样不高效, 本章学习一种高效的方式.

With a pair of Tree a and Breadcrumbs a, we have all the information to rebuild the whole tree and we also have a focus on a sub-tree.

```hs
type Zipper a = (Tree a, Breadcrumbs a)
```
