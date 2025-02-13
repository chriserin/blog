# Nested CSS is valid in major browsers

It might have been a while since I have written CSS. I've always been a fan of
SCSS with its variables and nesting. I knew browsers could natively define
and use css variables now, but I'm just now learning that I can nest CSS
selectors just like in SCSS. [Since 2023](https://caniuse.com/css-nesting)

```css
header {
  a {
    color: var(--pleasantly-surprised);
  }
}
```
