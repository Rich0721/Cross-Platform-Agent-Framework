# Agent Config Framework

此專案主要是為了提供一個在使用不同代理人系統(Github Copilot、Codex、Cursor)時，能夠不需要手動或重新設定就可以使用同一個Agent的框架進行設定，方便開發者在多代理人環境下進行協作與開發。
不過因不同系統間有些許不同的設定與操作方式，使用者仍需依照各系統的特性進行適當的調整。

## 資料夾結構

```text
agent-config/
├── .agents/
├── .github/
├── agents/
│   ├── system-design-agent.md
│   ├── programmer-agent.md
│   └── code-review-agent.md
├── Features/
│   ├── Document/
│   ├── Plan/
│   ├── Issue/
│   └── Review/
├── instructions/
├── AGENTS.md
├── README.md
```
### 詳細說明
| 資料夾 | 說明 |
|--------|------|
| `.agents/skill/` | 存放代理人需要使用到的技能包，方便在不同代理人系統中共用。 |
| `.github/` | GitHub相關設定檔，包含VS Code可以呼叫到指定的Agent，但內容只會引導至閱讀另外一個文件 |
| `agents/` | 存放各種代理人設定文件 |
| `Features/` | 存放需求文件、計畫、問題與審查等資料夾 |
| `Features/Document` | 存放需求文件(此部分由使用者撰寫) |
| `Features/Plan` | 存放系統設計與實作計畫 |
| `Features/Issue` | 存放開發過程中提出的問題 |
| `Features/Review` | 存放程式碼審查意見 |
| `instructions/` | 存放該專案的相關架構檔案 |
| `instructions/project.md` | 專案相關架構說明文件，所有Agent都會先根據此文件進行相關設定，也可以透過此文件進行額外參考 |
| `AGENTS.md` | 代理人總覽文件 |
| `README.md` | 專案說明文件 |


## 功能
目前此框架設定可以使用`Github Copilot`、`Codex`和`Cursor`，進行客製化代理人開發，主要分成三種代理人(Agent):
- [System Design](./agents/system-design-agent.md)：專門負責系統設計與架構規劃。
- [Programmer](./agents/programmer-agent.md)：專門負責程式開發與實作。
- [Code Review](./agents/code-review-agent.md)：專門負責程式碼審查與品質控制。


### System Design Agent
此Agent主要根據使用者撰寫的需求文件(Features/Document)進行系統設計與架構規劃，並不會直接進行程式開發。
#### Workflow
```text
    閱讀需求文件(Features/Document)
            |
            ▼
  進行系統設計與實作計畫(Features/Plan)
            |
            ▼
  確認是否有Programmer Agent的開發疑問(Feature/Issue)
            |
            ▼
  完成系統設計與實作計畫(Features/Plan)
```

如果工作過程中因`需求文件`未完整導致Agent無法進行相關設計的話，它會列出相對問題請使用者補充完整，才有辦法進行分析，否則將無法進行Programmer的動作。


### Programmer Agent
此Agent主要負責程式開發與實作，根據System Design Agent提供的系統設計與實作計畫(Features/Plan)進行程式開發，並在開發過程中提出可能的問題(Feature/Issue)給System Design Agent確認。

#### Workflow
```text
    接收系統設計與實作計畫(Features/Plan)
            |
            ▼
  進行程式開發與實作
            |
            ▼
  提出開發過程中的問題(Feature/Issue)
            |
            ▼
  確認問題後繼續開發
            |
            ▼
  完成程式開發與實作
```

### Code Review Agent
此Agent主要負責程式碼審查與品質控制，根據Programmer Agent提交的程式碼進行審查，並提出改進建議(Feature/Review)給Programmer Agent。

#### Workflow
```text
接收程式碼審查請求(Features/Plan)
            |
            ▼
  進行程式碼審查
            |
            ▼
  提出審查意見(Feature/Review)
            |
            ▼
  確認問題後程式碼修改
            |
            ▼
  完成程式碼審查
```

## Skills

此專案中的代理人可以使用的技能包存放於`.agents/skill/`資料夾中，方便在不同代理人系統中共用。使用者可以根據需求`新增`或`修改`技能包，以擴展代理人的能力。

## 未來展望
目前三個Agent都屬於在同一個使用者的環境下運作，所以工作流程未納入使用`git`進行版本控制的情境，相關版控都是由使用者自行管理。未來可能會考慮整合版本控制功能，使多代理人協作更加順暢。

## 測試專案
以下為作者用來測試此多代理人框架的專案列表：
1. [後端管理系統](https://github.com/Rich0721/manage-backend)