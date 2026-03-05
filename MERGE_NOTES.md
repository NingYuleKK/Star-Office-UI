# Merge Notes: upstream/master → merge-upstream-v2

**创建时间**: 2026-03-04
**目标**: 把 ringhyacinth/Star-Office-UI 的 2026-03-04 大更新合并进来

## 冲突文件清单

### 1. `frontend/index.html` ⚠️ 最重要
**需要保留的奉孝定制内容**（已确认行号，合并后需手动恢复）:
- Line 6: `<title>奉孝的像素办公室</title>`
- Line 1110: `正在加载 奉孝的像素办公室...`
- Line 1140: `<div id="control-bar-title">奉孝状态</div>`
- Line 1554: `` `正在加载 奉孝的像素办公室... ${percent}%` ``
- Line 4000-4006: 像素风牌匾 `'奉孝🦊的办公室'`

**upstream 的默认值**（需替换为奉孝版本）:
- "Star 的像素办公室" → "奉孝的像素办公室"
- "Star 状态" → "奉孝状态"
- "海辛小龙虾的办公室" → 这个是 officeTitle，检查是否需要改

### 2. `backend/app.py` ⚠️ 结构性重写
**需要保留的本地改动**:
- `MEMORY_DIR = os.path.expanduser("~/.openclaw/workspace/memory")` — upstream 改成了相对路径，要改回来

**upstream 新增依赖**:
- `security_utils.py`, `memo_utils.py`, `store_utils.py` — 三个新文件，已在 merge 中自动加入
- PIL (Pillow) — 图片处理，需要 `pip install Pillow`

### 3. `README.md`
- 保留 upstream 的新版本即可，本地改动不重要

### 4. `join-keys.json`
- upstream 删除了这个文件，但本地有实际 join key 数据
- 策略：保留本地版本（已有真实数据，不能丢）

## 操作步骤（明天执行）

```bash
cd ~/Star-Office-UI

# 1. 确认在 merge-upstream-v2 分支（merge 已经 --no-commit 暂存）
git status

# 2. 解决 app.py 冲突
#    - 接受 upstream 的大部分重写
#    - 手动把 MEMORY_DIR 改回: os.path.expanduser("~/.openclaw/workspace/memory")
nano backend/app.py  # 搜索 <<<<<<< 解决冲突

# 3. 解决 index.html 冲突
#    - 接受 upstream 的新版本
#    - 用上面的奉孝定制内容替换对应的 "Star" 字样
nano frontend/index.html

# 4. 解决 README.md 冲突
#    - 接受 upstream 版本
git checkout upstream/master -- README.md

# 5. 处理 join-keys.json
#    - 保留本地版本
git checkout HEAD -- join-keys.json

# 6. 安装新依赖
pip install Pillow

# 7. 提交
git add -A
git commit -m "feat: merge upstream v2 (美术资产重绘/资产管理/生图API/三语支持)"

# 8. 重启 Flask
#    - 先停掉当前 Flask 进程
#    - cd backend && python3 app.py &

# 9. push 到 origin
git push origin merge-upstream-v2
```

## 新功能说明

- **资产管理侧边栏**: 可替换角色/场景/装饰/按钮等素材
- **生图 API**: 支持 Gemini nanobanana-pro 换背景装修
- **三语支持**: 中/英/日
- **desktop-pet**: 新增 Tauri 桌面宠物版（可单独探索）
- **美术资产全面重绘**: 猫咪/咖啡机/按钮等

## 风险备注

- Flask 重启期间 fengxiao.cc 短暂不可访问（约1-2分钟）
- join-keys.json 如果丢失，现有访客需要重新加入
