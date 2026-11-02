---
name: playwright
description: 撰寫、修改或審查相關Playwright E2E程式碼使用。以Python作為API示範具體的元素定位、容器內操作、斷言、網路模擬與需求追溯寫法；其他語言沿用相同測試意圖與定位邊界。
---

# Playwright Skill

## Overview

此Skill會根據開發者提供情境說明或情境文件，撰寫對應可閱讀、可維護的 Playwright測試程式碼。
- 如果是直接進行口述情境，程式碼開頭應顯示「前置資料 → 定位範圍 → 操作 → 預期結果」。
- 如果提供情境來源，程式碼應提供「情境來源」於開頭即可，不需要再重複描述前置資料與操作。

本Skill以Python作為示範語言，展示 Playwright 的同步 API 與 pytest-playwright 的 `page` fixture 用法。若開發指定其他語言撰寫，應轉換為對應語言的 API 與生命週期，保留情境、定位範圍及斷言語意。

除第一個完整範例外，各片段假設已匯入 `Page`、`expect`，且 `page` 已進入指定測試畫面。HTML、需求編號、欄位名稱與回應格式均為示例，實作時必須對照真正需求與頁面，不直接套用虛構規格。

## Core Principles

- 每個測試聚焦一個可辨識的使用者情境。
- 先定位功能容器，再操作其中的欄位與按鈕。
- Locator 變數名稱表達業務用途，例如 `profile_panel`，避免使用`div1`、`button2` 等無意義名稱。
- 每個主要操作後驗證契約要求的結果。
- 以可重試的 `expect` 等待畫面，不使用固定睡眠推測完成。
- 保留需求來源與前置條件，註解說明定位原因、特殊資料及模擬限制。
- 不使用 `.first`、`nth()` 或 `force=True` 掩蓋定位歧義與介面問題。
- 不以 `set_content()` 重建產品畫面後宣稱已驗證產品功能，應以`page.goto()` 進入真實應用程式頁面進行測試。
- 測試案例應保持獨立性，避免相互依賴。
- 測試案例應保持可重現性，避免依賴外部狀態或順序。
- 測試過程中，如果情境文件有要求需要進行截圖至指定資料夾，應確保截圖檔案命名清楚且可追溯至對應案例。

## Scenario Traceability

Function Name應以測試條件及預期行為命名，例如 `test_profile_save_updates_display_name`。
並且相關註解應根據下列原則進行撰寫，確保測試文件可追朔需求來源，方便日後維護與審查。
```python
  # 開發者以口述提供測試情境，例如:修改顯示名稱後，畫面應呈現新名稱。
  def test_profile_save_updates_display_name(page: Page) -> None:
      """情境：修改顯示名稱後，畫面應呈現新名稱。
      
      前置：已登入的測試會員，初始名稱為「原名稱」。
      操作：在個人資料區修改名稱並儲存。
      預期：出現成功提示，摘要更新為新名稱。
      邊界：真實測試後端，沒有模擬儲存回應。
      """

  # 開發者提供需求來源，例如: PROFILE-01／驗收條件 AC-2
  def test_profile_save_updates_display_name(page: Page) -> None:
      """來源：PROFILE-01／驗收條件 AC-2""" 
```
若開發者提供整份情境文件，需確認該文件情境與測試程式碼保持一致，確保每個測試案例都能追溯到對應的需求或驗收條件。

## Code Standards

### I. 容器定位原則

輸入或點擊相關元素時，應先定位最小可辨識的容器，避免全頁搜尋造成定位不明確與測試脆弱。
- 如果有穩定的id，應優先使用 CSS id 定位，不依賴深層 DOM 路徑或自動產生的 class。
- 如果沒有穩定的 id，應先確認真實 DOM 與定位契約，再選擇語意標籤或測試識別值進行定位。

```python
# 頁面可能同時存在其他區塊的儲存按鈕。
page.get_by_role("button", name="儲存").first.click()
```

| 介面情境 | Python 寫法 |
|---|---|
| 穩定的容器 id | `page.locator("#profile-panel")` |
| 區塊內的按鈕 | `panel.get_by_role("button", name="儲存", exact=True)` |
| 有關聯標籤的欄位 | `panel.get_by_label("顯示名稱", exact=True)` |
| 約定的測試識別值 | `panel.get_by_test_id("saved-name")` |
| 容器內一般文字 | `panel.get_by_text("沒有資料", exact=True)` |
| iframe 中的欄位 | `page.frame_locator("#payment-frame").get_by_label("姓名")` |


#### 1-1. 以 div 定位容器

適用情境: 頁面中有多個相似區塊，需操作特定區塊內的元素，假設頁面結構如下：
```html
<div id="profile-panel">
  <label for="display-name">顯示名稱</label>
  <input id="display-name" />
  <button type="button">儲存</button>
  <p role="status"></p>
  <span data-testid="saved-name"></span>
</div>
<div id="billing-panel">
  <button type="button">儲存</button>
  <p role="status"></p>
</div>
```

應先鎖定容器，再使用容器內的語意定位：

```python
profile_panel = page.locator("div#profile-panel")
expect(profile_panel).to_have_count(1)
expect(profile_panel).to_be_visible()

name_input = profile_panel.get_by_label("顯示名稱", exact=True)
save_button = profile_panel.get_by_role("button", name="儲存", exact=True)

name_input.fill("測試會員")
save_button.click()

expect(profile_panel.get_by_role("status")).to_have_text("儲存成功")
expect(profile_panel.get_by_test_id("saved-name")).to_have_text("測試會員")
```

`div#profile-panel`:同時限定標籤與 id，限縮定位範圍。選擇是否限制標籤應依頁面契約，不為無關的容器標籤變動增加脆弱性。

`page.locator()` 建立定位描述，不代表元素已存在；需透過後續操作或斷言等待條件。Locator 可在畫面重新渲染後重新定位元素，不需要預先保存 DOM 節點。

#### 1-2. 依列表內容縮小範圍

適用情境：每列都有「編輯」按鈕，需操作訂單 ORD-1001，假設每列是表格 row，且訂單號是完整的 cell 文字，假設頁面結構如下：
```html
<table role="table" name="訂單列表">
  <tr role="row">
    <td role="cell">ORD-1001</td>
    <td role="cell"><button type="button">編輯</button></td>
  </tr>
  <tr role="row">
    <td role="cell">ORD-1002</td>
    <td role="cell"><button type="button">編輯</button></td>
  </tr>
</table>
```

```python
orders_table = page.get_by_role("table", name="訂單列表", exact=True)
order_row = orders_table.get_by_role("row").filter(
    has=page.get_by_role("cell", name="ORD-1001", exact=True)
)
expect(order_row).to_have_count(1)
order_row.get_by_role("button", name="編輯", exact=True).click()

edit_dialog = page.get_by_role("dialog", name="編輯訂單", exact=True)
expect(edit_dialog).to_be_visible()
expect(edit_dialog.get_by_label("訂單編號")).to_have_value("ORD-1001")
```

`filter(has=...)` 的內部定位相對於候選列查找。只有順序本身是需求時才使用 `nth()`，例如驗證排序後第一筆資料；不可用固定列號取代資料身分。


### II. Selection與Checkbox驗證

假設需要驗證使用者在偏好設定面板中對通知與語系的選擇是否正確保存，並確保介面顯示設定已儲存的訊息，假設頁面結構如下:
```html
<div id="preferences-panel">
  <label for="notifications">接收通知</label>
  <input type="checkbox" id="notifications" />

  <label for="language">語系</label>
  <select id="language">
    <option value="zh-TW">中文</option>
    <option value="en-US">English</option>
  </select>

  <button type="button">儲存</button>
  <div role="status"></div>
</div>
```

```python
preferences = page.locator("#preferences-panel")
preferences.get_by_label("接收通知", exact=True).check()
preferences.get_by_label("語系", exact=True).select_option("zh-TW")
preferences.get_by_role("button", name="儲存", exact=True).click()

expect(preferences.get_by_label("接收通知", exact=True)).to_be_checked()
expect(preferences.get_by_label("語系", exact=True)).to_have_value("zh-TW")
expect(preferences.get_by_role("status")).to_have_text("設定已儲存")
```

元素方法說明：
- `Checkbox`：check() 用於`勾選`，uncheck() 用於`取消勾選`。
- `Select`：select_option() 用於選擇下拉選項，傳入 value、label 或 index。
- `Input`：通常使用`fill()`填入文字即可；除非需求涉及逐鍵事件，才使用 `press_sequentially()`。
- `快捷鍵`：使用 `press()` 模擬按鍵操作，例如 `page.get_by_label("輸入框").press("Enter")`。


### 等待結果與失敗訊息

應該使用`expect()` 來等待並驗證結果，而不是設定固定等待時間，因為 `expect()` 會自動等待條件成立，避免過短或過長的等待。

```python
# 應使用 expect() 來等待並驗證結果
status = page.locator("#profile-panel").get_by_role("status")
expect(status, "PROFILE-01：儲存後應顯示成功提示").to_have_text("儲存成功")

# 不可透過設定固定時間等待結果
page.wait_for_timeout(3000)
assert status.inner_text() == "儲存成功"
```

### API 模擬與介面錯誤

測試第三方API成功或失敗的處理邏輯，需模擬不同回應情境，確保前端能正確顯示訊息並保留使用者輸入。

```python
# 假設端點為 `/api/profile`，更新方法為 PUT，錯誤內容格式如下。
from playwright.sync_api import Route


def fail_profile_save(route: Route) -> None:
    if route.request.method == "PUT":
        route.fulfill(
            status=503,
            content_type="application/json",
            body='{"code":"SERVICE_UNAVAILABLE"}',
        )
    else:
        route.continue_()


page.route("**/api/profile", fail_profile_save)
try:
    panel = page.locator("#profile-panel")
    panel.get_by_label("顯示名稱", exact=True).fill("保留此名稱")
    panel.get_by_role("button", name="儲存", exact=True).click()

    expect(panel.get_by_role("alert")).to_have_text("暫時無法儲存")
    expect(panel.get_by_label("顯示名稱", exact=True)).to_have_value("保留此名稱")
finally:
    page.unroute("**/api/profile", fail_profile_save)
```

### 下載與新分頁

```python
# 情境：匯出報表會觸發下載。先註冊事件等待，再點擊
with page.expect_download() as download_info:
    page.locator("#report-panel").get_by_role(
        "button", name="下載報表", exact=True
    ).click()

download = download_info.value
assert download.failure() is None
assert download.suggested_filename == "report.csv"
```

若契約包含報表內容，還需在 Context 關閉前保存並檢查內容，不能只驗證檔名。

```python
# 情境：說明連結會開啟新分頁
with page.expect_popup() as popup_info:
    page.get_by_role("link", name="使用說明", exact=True).click()

help_page = popup_info.value
expect(help_page.get_by_role("heading", name="使用說明", exact=True)).to_be_visible()
```

### 封裝重複操作

如果有多個案例重複且具有穩定語意時，可以將相關操作抽取為`函式`或`Page Object`。但情境的預期結果應保留在案例中，而非封裝在輔助函式內。

```python
from playwright.sync_api import Locator


def save_display_name(panel: Locator, name: str) -> None:
    panel.get_by_label("顯示名稱", exact=True).fill(name)
    panel.get_by_role("button", name="儲存", exact=True).click()


profile_panel = page.locator("#profile-panel")
save_display_name(profile_panel, "測試會員")
expect(profile_panel.get_by_test_id("saved-name")).to_have_text("測試會員")
```

## 測試設定

應使用`os.getenv()` 來取得環境變數，提供測試方所需的基礎配置參數，例如專案的基底位址、登入憑證或其他必要的環境設定。

