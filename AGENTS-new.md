# Multi-Agent Architecture

## Overview
這是一個多代理系統的架構說明，描述各個代理之間的互動與協作方式與相關的資料夾結構安排，與個別代理人相關的職責、工作流程、指令與技能，應根據個別資料夾定義進行詳細規劃。

## Folder Structure
| Folder Path    | Description                              |
| -------------- | ---------------------------------------- |
| .agents/skills | 存放專案所需要的技能模組，提供每個代理人使用 |
| .agents/agents | 存放各個代理人的職責與工作流程說明，並透過`AGENTS.md` 進行統一管理 |
| .agents/instructions | 存放專門針對不同開發情境所需要的指令與規範，例如:Python Code Standard、後端MVC架構等 |
| .agents/instructions/common-instructions.md | 存放此專案中，所有代理人皆需要遵守的共用指令與規範 |
| .agents/instructions/folder-structure.md | 存放專案中關於資料夾結構的指令與規範 |
| .github        | 主要存放Github相關代理人所需的基本配置，但是會使它導讀至共用配置檔案，減少重複撰寫代理人的職責與流程說明 |

```text
project-root/
├─ .agents/
│  ├─ skills/
│  ├─ agents/
│  └─ instructions/
│     └─ common-instructions.md
└─ .github/
```

## Agents

此章節主要說明各個代理人的職責、工作流程以及代理人之間的互動方式。
- [System Design Agent](.agents/agents/system-design-agent.md)
- [Code Review Agent](.agents/agents/code-review-agent.md)
- [Programmer Agent](.agents/agents/programmer-agent.md)


### System Design Agent
主要負責閱讀`PM`所提出的需求，並根據專案需求進行系統設計與規範，並將相關計畫內容整理與紀錄至指定資料夾中，主要工作為：
- Requirement Analysis
- Requirement Change Analysis
- Bug / Behavior Analysis
- Existing System Analysis
- System Design
- Impact Analysis
- Implementation Plan
- Plan Update

### Code Review Agent
主要負責對程式碼進行審查，確保程式碼符合專案規範與設計要求，並將審查結果與回饋紀錄至指定資料夾中。
主要工作為：
- Implementation Review
- Code Quality Review
- Plan Compliance Review
- Test Review
- Regression Risk Review
- Review Fix Validation

### Programmer Agent
主要負責根據`System Design Agent`所提供的系統設計與規範進行程式開發，並將開發過程中的問題與進度紀錄至指定資料夾中。同時根據`Features/Review`中的回饋進行程式碼修改與優化，確保最終程式碼符合專案需求與規範。
主要工作為：
- Application Implementation
- Unit Test Implementation
- Regression Fix
- Plan Update Implementation
- Code Review Fix

### Agents Working Method

代理人工作模式：**Manual**

請根據*代理人工作方法*進行對應的操作與配置
- **Manual**：切換代理人之間的作業由使用者自行操作與控制，包含想要使用的代理人與模型的選擇與切換，相關[工作流程](./agents-references/images/Manual-Workflow.mmd)
- **Automatic**：代理人之間的作業由系統自動進行，根據預先設定的規則與流程，自動選擇適當的代理人與模型完成任務，相關[工作流程](./agents-references/images/Automatic-Workflow.mmd)


## Skills
*Skills*主要根據專案需求提供代理人所需要的技能模組，代理人根據需求選取並使用相應的技能模組完成任務，可根據專案需求進行擴充與調整。

## Instructions
*Instructions*主要放置專案中各個代理人應遵守的指令與規範，包含共用指令與專屬指令，代理人需根據需求遵循相應的指令與規範完成任務。
- `common-instructions.md`：存放此專案中，所有代理人皆需要遵守的共用指令與規範，包含開發程式語言與版本、專案選用的技術與工具、前後端的資料夾開發架構等，以及哪些行為須`參考專屬指令與規範`。
- `Other instructions`：根據不同代理人的需求與專案情境，存放專屬於特定代理人的指令與規範，例如針對前端開發、後端開發或資料庫管理等的專屬指令與規範，**必須撰寫進common-instructions.md參考引用**。
- `folder-structure.md`：存放專案資料夾結構的說明，包含各個資料夾的用途與規範，代理人應依照此指令進行資料夾的管理與使用。

代理人應嚴格遵守專案中的指令與規範，並從`common-instructions.md`閱讀相關規範，必要時須要根據內容參考`Other instructions`中的專屬指令與規範。相關開發的檔案位置應依照`folder-structure.md`中的規範進行管理與使用，如果有*不明確*或*未涵蓋*的情況，應及時向專案負責人說明，並由專案負責人協助調整相關文件，*禁止*自行決定或忽略相關規範。

## Features Folder
`Features`資料夾主要是為了讓`PM`、`開發人員`與`代理人`之間進行`需求說明`、`流程圖`、`情境範例`等交流與管理，讓代理人間也可以透過`Plan`、`Review`等文件進行協作與溝通，但相關資料夾結構應依照`folder-structure.md`中的規範進行管理與使用，但主要結構需要有以下資料夾
| Folder   | Description |
| -------- | ----------- |
| Document | 存放需求說明、流程圖與情境規範的文件，所有代理人都**禁止**修改內部文件 |
| Plan     | 由System Design Agent根據需求所制定的計畫與設計文件，所有代理人應依照此計畫進行相關工作，僅有**System Design Agent**可以大量修改此文件；**Code Review Agent**與**Programmer Agent**僅能根據計畫進行操作與執行，並且修改指定的部份內容 |
| Issue    | 由**開發人員**或**Programmer Agent**提出的問題與缺陷，*System Design Agent*應根據內容進行分析與調整相關計畫，提供給**Programmer Agent**進行修正與處理 |
| Review   | 由**Code Review Agent**對程式碼進行審查後的回饋與建議，**Programmer Agent**應根據回饋進行程式碼修改與優化，確保最終程式碼符合專案需求與規範 |

### Features Markdown Files Illustration

| File   | Description |
| -------- | ----------- |
| [需求說明範例](./agents-references/examples/01-feature-examples.md)| 需求說明範例，內容包含需求說明、Request body、Response body、Gherkin、mmd等相關文件與資料，由`PM`與`開發人員`自行撰寫，**代理人**僅根據內容回饋、提出建議與設計計畫，無法自行修改原始需求內容 |
| [計畫範例](./agents-references/examples/02-plan-example.md)| **System Design Agent**參考需求文件後，根據此範例架構進行實作計畫的撰寫，**Code Review Agent**與**Programmer Agent**僅能根據計畫進行操作與執行，並且僅能修改**Requirement List** |
| [議題範例](./agents-references/examples/03-issue-example.md)| 由`開發人員`或`Programmer Agent`提出的問題與缺陷範例，供**System Design Agent**進行分析與調整相關計畫，並提供給**Programmer Agent**進行修正與處理 |
| [審查範例](./agents-references/examples/04-review-example.md)| 由`Code Review Agent`對程式碼進行審查後的回饋與建議範例，供`Programmer Agent`根據回饋進行程式碼修改與優化 |

