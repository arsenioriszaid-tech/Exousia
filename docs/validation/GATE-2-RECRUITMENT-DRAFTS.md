# Gate 2 — Recruitment drafts (publish from Arsenio's accounts)

Contact placeholder: replace `[CONTACT]` with your email/handle before posting.
Do not invent replies, volunteers, or results — real responses only.

// ── DRAFT 1: Hacker News (post as comment in a relevant agent/permissions thread,
// or as Ask HN if none fits) ──────────────────────────────
Title (if Ask HN): Ask HN: Willing to test an experimental local permission layer for coding agents?

Body:
I'm validating (not launching) an experimental local-first control layer for
autonomous coding agents: low-risk actions auto-proceed, risky ones escalate, secrets/
prod writes deny — enforced locally below agent-writable config, with a tamper-evident
audit log. Linux-only, root, research prototype, expect rough edges.

Looking for 5-10 developers who actively use Claude Code / Codex / OpenCode / Gemini /
Aider to try it on a NON-SENSITIVE repo for ~1 hour and answer 8 short questions
(task done? interruptions vs your norm? did a boundary feel right? would you miss it?
what would you pay for?). Skeptics especially welcome — I'm trying to disprove this,
not to collect praise.

Install is files-only, auditable, reversible, no telemetry, no cost. Details + safety
rules in the repo. Reply here or [CONTACT] if in.

// ── DRAFT 2: Reddit (r/ClaudeCode, r/OpenCode, or r/LocalLLaMA) ────────────
Title: [Research] Testers wanted: experimental local permission layer for coding agents (Linux, 1 hr, skeptics welcome)

Body:
Hi all — I'm running a validation experiment (Gate 2 of a build-in-public research
repo, Exousia) and need 5-10 testers, ideally including people annoyed by approval
popups AND people who think YOLO mode is fine.

What: a local enforcement layer — your agent works inside it, low-risk stuff runs
free, secret/prod/destructive stuff gets denied, everything logged. Goal: fewer
interruptions without giving the agent the keys to everything.

Ask: ~1 hour on a NON-SENSITIVE repo (never your real secrets — you plant a fake one
for the boundary test), then 8 short questions. Linux + root required (uses Linux
namespaces/Landlock), your own model keys as usual, zero cost, uninstall is one command.

Not selling anything; there is no product, no signup, no telemetry. Trying to find out
if this should exist at all — negative results ("useless, uninstalled") are the most
valuable data.

Interested? Comment or [CONTACT]. Full protocol + safety rules: [REPO LINK, branch
gate-2/real-user-validation].

// ── Posting notes ─────────────────────────────────────────
- Post D1 only where topical (reply > new thread when a permissions/YOLO thread exists).
- Do not cross-post simultaneously; stagger by 2-3 days; max 3 communities.
- Log every post URL + date in GATE-2-RESULTS.md when created.
- Stop rule: 2 weeks, zero volunteers → INCONCLUSIVE leaning KILL (per protocol).

// ══ ROUND 2: new-account channels (X + Threads + FB Indonesia) ═══════════
// Context: founder has no established Reddit/HN identity. These drafts are written
// for fresh accounts: story-first, link-in-reply, skeptic-welcoming. Contact =
// your handle on that platform (DMs open) unless stated otherwise.

// ── DRAFT 3: X thread (English, skeptics-global) ─────────────
// Tactic: 2-3 days of genuine replies on Claude Code / AI-coding threads first.
// Post 6 tweets as ONE thread, evening WIB. No links until tweet 5.
1/ Measured problem: Claude Code users approve 93% of permission prompts (Anthropic's
own telemetry). OpenAI reports the same fatigue → users flip to Full Access/YOLO.
Per-command approval is security theater. I'm validating whether a local
autonomy-with-boundary layer should exist at all.
2/ What I built to test it (not a product): a local enforcer — low-risk actions run
free, secrets/prod/destructive get denied, everything in a tamper-evident audit log.
Linux namespaces + Landlock, zero cloud, zero telemetry. Expect rough edges.
3/ What I need: 5 devs using Claude Code / Codex / OpenCode / Gemini who'll spend
~1hr on a NON-SENSITIVE repo and answer 8 short questions. Especially people who
think approval popups are useless OR that YOLO is fine — I'm trying to DISPROVE this.
4/ What you get: nothing to buy, no signup. Files-only installer (auditable,
reversible), your own model keys as usual. Worst case you confirm it's useless —
that result is literally the most valuable data to me.
5/ Protocol + safety rules + install: [REPO LINK, branch gate-2/real-user-validation]
6/ Reply or DM if in. If this flops publicly, that flops publicly — that's the point
of validation. /end

// ── DRAFT 4: Threads (casual cross-post) ─────────────────────
Trying to kill my own idea in public: does anyone actually want a local permission
layer for AI coding agents, or are approval popups fine / YOLO fine?

Need ~5 devs (Claude Code, Codex, OpenCode users) for a 1-hour test on a non-sensitive
repo. Linux + root, nothing to install except auditable files, no signup, no cost.
"this is useless" is an accepted — celebrated — answer.

Details in repo (link in reply). DM me if you're in 🤝

// ── DRAFT 5: Facebook group Indonesia (Bahasa, komunitas lokal) ──
// Taktik: baca rules grup → DM admin dulu ("min, izin share riset 1x ya") → posting.
// Grup yang cocok: komunitas programming/Python/web Indonesia yang aktif.
Halo semuanya, izin share 🙏

Saya lagi jalanin riset validasi (BUKAN jualan, belum ada produk): lapisan kontrol
lokal buat AI coding agent — biar agent bisa kerja mandiri tanpa approval tiap detik,
tapi secret/prod/aksi berbahaya tetap diblokir. Jalan lokal di Linux, tanpa cloud,
tanpa telemetri.

Butuh 3–5 teman-teman yang pakai Claude Code / Codex / OpenCode / Gemini buat uji
coba ~1 jam di repo NON-SENSITIF (jangan repo berisi secret beneran — nanti dikasih
file secret PALSU buat ngetes batasnya), terus jawab 8 pertanyaan singkat.

Yang skeptis ("ngapain dibatesin, YOLO aja") justru paling dicari — saya lagi usaha
MEMBANTAH ide ini, bukan cari pujian. Kalau hasilnya "nggak guna", itu data terbaik.

Syarat: Linux + akses root + API key sendiri seperti biasa. Installer cuma copy file
(bisa dibaca dulu), uninstall 1 perintah, gratis.

Minat? Komen/DM ya. Protokol lengkap + aturan safety ada di repo: [LINK REPO,
branch gate-2/real-user-validation]. Makasih banyak! 🙏

// ── New-account posting rules ────────────────────────────────
- Never lead with links/installer commands — story + numbers first, link in reply.
- X: reply-guy 2-3 hari dulu; posting perdana = thread di atas, jangan promo lain.
- FB: izin admin dulu terbukti menaikkan acceptance drastis; hormati penolakan.
- Pick max 2 channels. Stagger: FB dulu (konversi tercepat), X 2-3 hari kemudian.
- Stop rule tetap: 2 minggu sejak postingan pertama tayang, nol relawan →
  INCONCLUSIVE leaning KILL. Catat semua URL + tanggal posting.
