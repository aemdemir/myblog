---
title: "Setting Up a Pretty and Minimal macOS Terminal"
date: 2021-12-29T11:53:23+03:00

tags: ["macos", "terminal", "zsh"]

showtoc: false

cover:
    image: "setting-up-a-pretty-and-minimal-macos-terminal/cover.png" # image path/url
    alt: "a sample look of our terminal"
    caption: "a sample look of our terminal"
    relative: false # when using page bundles set this to true
---

Using the default terminal is fine, but why not have a better terminal, especially a pretty and minimal alternative? In this guide, we will set up a pretty and minimal terminal with little effort. Our terminal will have a nice look, syntax highlighting, git info, auto-completion and other features just out-of-the-box.

## Prerequisites

#### Install Homebrew

We will need [**`Homebrew`**](https://brew.sh) to install the packages we need.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Using ZSH 5.0.8 or above

ZSH is already the default shell for macOS. So, probably it's all set. But, let's check that; `zsh --version` should be 5.0.8 or higher, and also `echo $SHELL` should be `/bin/zsh` or similar. If checks are failed, then follow the below steps for using zsh.

- Install zsh: `brew install zsh`
- Make zsh the default shell: `chsh -s $(which zsh)`. If this not work due to non-standard shell error, use below commands instead.
    - `sudo sh -c "echo $(which zsh) >> /etc/shells"`
    - `chsh -s $(which zsh)`

## Terminal Configuration

### Step 1: Set a Theme

We will use [**`Dracula`**](https://draculatheme.com/terminal) theme for our Terminal. Just download it and after that click `Terminal - Preferences - Profiles - Import`, then select the `Dracula.terminal` file, and click default.

### Step 2: Basic Terminal Preferences

Open `Terminal - Preferences - Profiles - Dracula`, and set the followings (these are particularly my taste, feel free to change as you like)

- Text Panel
   - Font: `SF Mono Regular 14`
   - Cursor: `Block` & `Blink Cursor`

- Keyboard Panel
   - Activate `Use Option as Meta key`

{{< figure class="figure-center" src="/setting-up-a-pretty-and-minimal-macos-terminal/preferences.png" alt="a sample look of terminal preferences" caption="a sample look of terminal preferences" >}}

### Step 3: Install Oh My Zsh

We will use [**`Oh My Zsh`**](https://ohmyz.sh) to improve our zsh experience and bundle everything we need. It provides nice features such as colors, suggestions, auto-completion and so on. This will be our starting point and we will depend on Oh My Zsh as we follow the next steps.

```shell
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> We can install below tools separately (rather than depending on Oh My Zsh), but using Oh My Zsh makes the process more compact and easy to manage.

### Step 4: Install Powerlevel10k

We will use [**`Powerlevel10k`**](https://github.com/romkatv/powerlevel10k) to have a better prompt; highlights current directory, shows git info, shows command status, shows execution time and much more. It also has a configuration wizard which makes it so easy to configure.

- We will use Powerlevel10k with [Oh My Zsh](https://github.com/romkatv/powerlevel10k#oh-my-zsh).

```shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

- Set `ZSH_THEME="powerlevel10k/powerlevel10k"` in ~/.zshrc.

It's time to configure Powerlevel10k. If it doesn't trigger automatically, run `p10k configure`. Powerlevel10k doesn't require a custom font but it recommends [**`MesloLGS NF`**](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k); with this font available there will be more options when styling.

{{< figure class="figure-center" src="/setting-up-a-pretty-and-minimal-macos-terminal/powerlevel10k-extravagant-style.png" attrlink="https://github.com/romkatv/powerlevel10k#extremely-customizable" alt="Powerlevel10k Extravagant Style" attr="Powerlevel10k Extravagant Style" >}}

> In order to use recommended font follow the below steps: 
> - [Download](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k) font files, double-click on them and select `Install Font`
> - Go to `Terminal - Preferences - Profiles - Dracula - Text`
> - Set font to `MesloLGS NF`

I like to keep my terminal simple, so I don't need extra styling and hence the recommended font. So, keeping that in mind here's my configuration:

- Does this look like a `<something>`?: No `yes if using recommended font`
- Does this look like >< but taller and fatter?: Yes
- Prompt Style: Lean
- Character Set: Unicode
- Prompt Colors: 256 colors
- Show current time?: 24-hour format
- Prompt Height: One line
- Prompt Spacing: Compact
- Prompt Flow: Concise
- Enable Transient Prompt: No
- Instant Prompt Mode: Verbose

> If you want to reflect Dracula theme colors to your prompt, use one of the following styles: `Rainbow, Lean → 8 colors or Pure → Original`

### Step 5: Install Zsh Syntax Highlighting

We will use [**`zsh-syntax-highlighting`**](https://github.com/zsh-users/zsh-syntax-highlighting) to enable highlighting of commands as we type.

- We will use zsh-syntax-highlighting with [Oh My Zsh](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh).

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- Set `plugins=( [plugins...] zsh-syntax-highlighting)` in ~/.zshrc.

> I remove git from plugins since I don't see any extra benefit of it.

## Uninstallation

Don't you like what we did above? So let's just uninstall then.

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh#uninstalling-oh-my-zsh)
    - `uninstall_oh_my_zsh`
    - `rm ~/.zcompdump-{name}`
    - `rm ~/.zshrc.omz-uninstalled-{date}`

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k#how-do-i-uninstall-powerlevel10k)
    - `rm ~/.p10k.zsh`
    - Remove cache files: `rm -rf -- "${XDG_CACHE_HOME:-$HOME/.cache}"/p10k-*(N) "${XDG_CACHE_HOME:-$HOME/.cache}"/gitstatus`

- Dracula Theme
    -  Remove it from the `Terminal - Preferences - Profiles`

## Wrapping Up

That's all it takes. We did nothing except installing a couple of tools but we still have a terminal that looks nice, and has a lot features. That's more or less my own terminal setup; I like to keep it simple and avoid complex configurations. However, there is still room for customization. Just check out the docs.

> All of this should also work with Visual Studio Code's terminal without an extra step. However, if you are using [recommended font](#step-4-install-powerlevel10k) for Powerlevel10k, then follow the below steps:
> - Go to `Visual Studio Code - Preferences - Settings`
> - Search for `terminal.integrated.fontFamily` 
> - Set the value to `MesloLGS NF` 

{{< css.inline >}}

<style>
.figure-center {
	text-align: center;
}
</style>

{{< /css.inline >}}