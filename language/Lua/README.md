### 七周七语言

Lua 设计初衷: 脚本, 黏合

特点:

- table
- coroutine
  > 单线程的并发模型, node 也如此?
- tail recursion 优化

### 自学

#### 初识

- all is global
- set `nil` is delete

#### oop

> new 方法中, setmetatable(原型继承)
>
> https://www.lua.org/pil/16.1.html

```lua
local _M = {}

local mt = { __index = _M }

function _M.new (self, balance)
    balance = balance or 0
    return setmetatable({balance = balance}, mt)
end
```

#### metatable 原表

- lua 原型继承(较 js 更简洁):
  - setmetatable(table, metatable): 此方法用于为一个表设置`元表`
    ```lua
    t = setmetatable({[1] = "hello"}, {__index = {[2] = "world"}})
    ```
  - getmetatable(table): 此方法用于获取表的元表对象。
- 对比 js
  - 实例化对象的`__proto__`属性指向其`原型`
  - 原型本质是`对象`:
    - 对象就有`__proto__`, 所以形成了原型链.
  - 设置原型的`方式`:
    - `__proto__`直接赋值(`本质`): `http://javascript.ruanyifeng.com/oop/object.html#toc4`
    - `new`(上一种的特例): 实例`__proto__` -> 构造函数的`prototype`属性
    ```js
    var F = function() {}
    var f = new F()
    f.__proto__ == F.prototype //true
    ```
  - 原型上定义了的: 可被实例共享的`method`
- self

#### 16.3 Multiple Inheritance

- 单继承, 即`metatable`形成链.
- `__index`作为 meta method, 当做函数使用.
  > https://www.lua.org/pil/16.3.html

#### 点号与冒号操作符的区别

> https://moonbingbing.gitbooks.io/openresty-best-practices/content/lua/dot_diff.html

`:`是`.`是的语法糖, 是默认传入`self`代表自己, 而`.`则需要显示指定.

- 冒号的操作，只有当变量是类对象时才需要
- `.`获得的就是普通函数, 所以需要指定`操作对象`

#### Iterator function (\*)

- `for`作用于`function`, 此 function 称为`iterator`, 每次调用返回`next element`, 直到`nil`

```for
for word in allwords() do
  print(word)
end
```

### [Coroutine](https://www.lua.org/pil/9.1.html)

#### resume/yield 数据互传

```lua
-- 首次 resume, 传给 main function
co = coroutine.create(function (a,b,c)
        print("co", a,b,c)
      end)
coroutine.resume(co, 1, 2, 3)    --> co  1  2  3

-- 后续 resume, 传参
co = coroutine.create (function ()
        print("co", coroutine.yield())
      end)
coroutine.resume(co)
coroutine.resume(co, 4, 5)     --> co  4  5
```

- `coroutine.yield(i)`: `yield`会把`i`append 到对应`resume()`的返回值.
- `coroutine.resume(co, ...)`: `resume`传入的参数(非 first), 会作为上次`yield()`的返回值.
  - 首次`resume`, 会把参数传给`couroutine main function`

* lua 提供的是 `asymmetric coroutine`(非对称协程)
  - suspend/resume 是两个不同的`function`

#### 9.2 生产者/消费者

- 代码见`src/9.2.lua`
  > consumer-driven design (消费者, 需要了再 call)

#### 9.3 Coroutines as Iterators

> 和 9.2 个人改进思路相近, 不需要 while true

- `coroutine.wrap()`
