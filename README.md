# dyl6170.github.io

GitHub Pages 静态资源仓库，用于托管可直接在论坛/Markdown 中引用的 SVG 动画等资源。

## 目录结构

```
.
├── .nojekyll              # 关闭 Jekyll 处理
├── index.html             # 资源索引页（可选）
└── assets/
    └── images/            # 图片资源
```

## 使用方法

把文件放进 `assets/images/`，push 到 `main` 分支后即可访问：

```
https://dyl6170.github.io/assets/images/<文件名>
```

### 在论坛 / Markdown 中引用

```markdown
![描述](https://dyl6170.github.io/assets/images/pelican-bicycle-night.svg)
```

以 `<img>` 方式加载 SVG 时，浏览器会正常执行其中的 CSS / SMIL 动画。

## 命名建议

- **长期复用**的图用语义名（如 `pelican-bicycle-night.svg`），URL 稳定，老帖不会失效
- **一次性**的图用时间戳名（如 `20260913094941.svg`）
- ⚠️ 改名会让已发布的引用链接失效，确定后再改

## 注意

- Pages 有 CDN 缓存，同名文件更新后可能需要几分钟才刷新；内容变更建议换文件名
- 仓库必须为 Public（免费账号的 Pages 不支持私有仓库）
