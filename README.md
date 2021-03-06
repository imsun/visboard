Visboard
======

可编程的可视化工具。

[Demo](http://imsun.net/project/visboard/)

![visboard](http://imsun.gitcafe.com/img/visboard.png)

## Pipeline

Data -> Template -> Primitive -> Renderer -> Canvas

- Data / 数据: 读入数据并进行预处理。数据可以绑定到模板或图元。

- Template / 模板: 模板是一种特殊的图元，它封装了一组子图元，并将自己的属性映射到所包含图元相应的属性。

- Primitive / 图元: 图元通过一组属性定义。所有图元都在一个全局的图元列表里。

- Renderer / 渲染器: 渲染器根据全局的图元列表和绑定的数据来计算图元的属性值，生成一个基本绘制元素列表。

- Canvas / 绘制层: 绘制层根据渲染器生成的绘制元素列表进行绘制。注意，绘制层不进行可编程计算，也不访问数据，所有计算都在渲染器中完成。

根据不同的需求，可以将元素映射到不同的绘制层，如 WebGL，SVG，Canvas 等。示例中将元素映射到 D3 进行绘制。

另外不是所有能看到的属性都被映射到了绘制层，自己只映射了一些基本属性进行测试，如果有些属性的值改了没反应，说明我可能没有把该值映射到绘制层。


## 数据处理

点击菜单栏的 Data 添加数据或处理工具。

### New Data / 添加数据

上传数据文件，暂时只支持 CSV 文件。

### Filter / 过滤器

添加一个过滤器。

- Input: 输入数据

- Select: 被筛选出的列名，用英文逗号隔开。值为 "*" 时返回所有列

- Rules: 筛选条件，使用 `$data` 表示数据，使用 `$index` 表示行数。如 `$data.time > 0 && $index % 2`

### Cluster / 聚合器

添加一个聚合器。

- Input: 输入数据。

- Key: 输入数据的某个列名。将根据该列进行聚合

## 可编程

选中图元后，属性右侧的带有 "&lt;/&gt;" 的为编程按钮，点击后弹出编辑框，勾选 "Enable programming" 后可对属性进行编程。

```
/**
 * 编程示例。无相应属性时传入 null
 * @param  {Object} 图元所绑定的数据
 * @param  {Number}	图元对应的行数
 * @param  {Array} 图元所绑定的域
 * @param  {Object} 对父级图元上述属性的引用
 * @return 返回属性的值。返回类型据属性而定
 */
function($data, $index, $domain, $parent) {
    return $data.time * 10
}
```
