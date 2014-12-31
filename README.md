Visboard
======

## Workflow

Data -> Template -> Primitive -> Renderer -> Canvas

- Data: 读入数据并进行预处理。数据可以绑定到模板或图元。

- Template: 模板是一种特殊的图元，它封装了一组子图元，并将自己的属性映射到所包含图元相应的属性。

- Primitive: 图元通过一组属性定义。所有图元都在一个全局的图元列表里。

- Renderer: 渲染器根据全局的图元列表和绑定的数据来计算图元的属性值，生成一个基本绘制元素列表。

- Canvas: 绘制层根据渲染器生成的绘制元素列表进行绘制。注意，绘制层不进行计算，也不访问数据，所有计算都在渲染器中完成。

这里只实现了 Template, Primitive, Renderer 的基本功能。Template 和 Primitive 的扩展性比较好，可以很方便地扩展新的模板和图元。

数据的读入和预处理功能还没有做，Demo 里预置了一组数据用于测试。

绘制层现在是 D3，我将基本元素列表映射到了 D3 中进行绘制。不过更换绘制层很方便，只要改下属性的映射就可以了。

另外不是所有能看到的属性都被映射到了绘制层，自己只映射了一些基本属性进行测试，如果有些属性的值改了没反应，说明我没有把该值映射到绘制层。

## 步骤示例

### 示例一: 添加图元（坐标轴）

1. 点击 Add -> Axis

1. 将 Domain 改为 game.time

1. 将 Range 的第二个值改为 $domain[$domain.length - 1]

1. 将 Length 改为 500

1. 将 Ticks 改为 12

### 示例二: 添加图元（圆）

1. 点击 Add -> Circle

1. 将 Data 改为 game

1. 将 X 改为 $data.time / 5

1. 将 Y 改为 $data.difference * 10

### 示例三: 添加模板（散点图）

1. 点击 Add -> Scatter Plot

1. 将 Data 改为 game

1. 将 X Axis 改为 game.time

1. 将 Y Axis 改为 game.difference

1. 将 Width 改为 500

1. 选中 Scatter Plot 下的 y axis，将 Ticks 改为 4
