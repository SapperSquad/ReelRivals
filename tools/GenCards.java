// Reel Rivals promo card generator.
//
// WHY THIS EXISTS: through 1.2.1 the art in assets/ and promo/ was exported PNGs with no
// source file, so updating a single number meant redrawing a card by hand. This regenerates
// the cards whose content goes stale (gear ladder, milestones, progression blurb) from code.
//
// Run:  java tools/GenCards.java            (Java 11+ single-file launch; ASCII-only on purpose)
// Out:  promo/gallery-4-gear.png, promo/gallery-5-endgame.png, assets/card_progression.png
//
// Style is matched to the 1.2.1 hand-made set: dark teal gradient, bokeh, wave footer,
// teal "REEL RIVALS" eyebrow, heavy white headline with a yellow underline slab.

import java.awt.*;
import java.awt.font.TextAttribute;
import java.awt.font.TextLayout;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.text.AttributedString;
import java.util.Random;
import javax.imageio.ImageIO;

public class GenCards {

    // ---- palette ----------------------------------------------------------
    static final Color BG_DARK   = new Color(0x0C2E38);
    static final Color BG_LIGHT  = new Color(0x1C5F6B);
    static final Color TEAL      = new Color(0x35C5B0);
    static final Color YELLOW    = new Color(0xFFC845);
    static final Color WHITE     = Color.WHITE;
    static final Color BODY_GRAY = new Color(0xB4C2C6);

    static final Color ROD_ANGLER      = new Color(0x8B5A2B);
    static final Color ROD_MASTER      = new Color(0xB07FD0);
    static final Color ROD_CHAMPION    = new Color(0xFFC845);
    static final Color ROD_LEGEND      = new Color(0x35D3C8);
    static final Color ROD_NATURALIST  = new Color(0x6FCF7F);
    static final Color ROD_GRANDMASTER = new Color(0xE39BF0);

    // card-style (assets/) palette
    static final Color CARD_TOP    = new Color(0x0E2B44);
    static final Color CARD_BOTTOM = new Color(0x16506B);
    static final Color CARD_HEAD   = new Color(0xFFD24A);

    static String projectRoot() {
        // tools/GenCards.java -> project root is the parent of tools/
        File here = new File(System.getProperty("user.dir"));
        if (new File(here, "datapack/pack.mcmeta").exists()) return here.getPath();
        if (new File(here, "../datapack/pack.mcmeta").exists()) return new File(here, "..").getPath();
        return here.getPath();
    }

    public static void main(String[] args) throws Exception {
        String root = projectRoot();
        write(banner(),       new File(root, "promo/banner-1920x640.png"));
        write(gearLadder(),   new File(root, "promo/gallery-4-gear.png"));
        write(endgame(),      new File(root, "promo/gallery-5-endgame.png"));
        write(bounty(),       new File(root, "promo/gallery-6-bounty.png"));
        write(progression(),  new File(root, "assets/card_progression.png"));
        write(cardMarket(),   new File(root, "assets/card_market.png"));
        System.out.println("done");
    }

    static void write(BufferedImage img, File out) throws Exception {
        out.getParentFile().mkdirs();
        ImageIO.write(img, "png", out);
        System.out.println("wrote " + out.getPath() + "  (" + img.getWidth() + "x" + img.getHeight() + ")");
    }

    // ---- drawing helpers --------------------------------------------------

    static Graphics2D newCanvas(BufferedImage img) {
        Graphics2D g = img.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);
        g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        return g;
    }

    /** Diagonal teal gradient with a lighter pool up and to the right, like the 1.2.1 galleries. */
    static void galleryBackground(Graphics2D g, int w, int h) {
        g.setPaint(new GradientPaint(0, 0, BG_DARK, w, h, new Color(0x0A2630)));
        g.fillRect(0, 0, w, h);
        g.setPaint(new RadialGradientPaint(
                new Point2D.Float(w * 0.62f, h * 0.22f), w * 0.75f,
                new float[]{0f, 1f},
                new Color[]{new Color(BG_LIGHT.getRed(), BG_LIGHT.getGreen(), BG_LIGHT.getBlue(), 190),
                            new Color(BG_LIGHT.getRed(), BG_LIGHT.getGreen(), BG_LIGHT.getBlue(), 0)}));
        g.fillRect(0, 0, w, h);
        bokeh(g, w, h, 7L);
        waves(g, w, h);
    }

    /** Scattered soft dots. Seeded so reruns are byte-identical. */
    static void bokeh(Graphics2D g, int w, int h, long seed) {
        Random r = new Random(seed);
        for (int i = 0; i < 46; i++) {
            int d = 6 + r.nextInt(26);
            int x = r.nextInt(w), y = r.nextInt(h - 140);
            g.setColor(new Color(0x5F, 0xD8, 0xC8, 8 + r.nextInt(16)));
            g.fillOval(x, y, d, d);
        }
    }

    static void waves(Graphics2D g, int w, int h) {
        drawWave(g, w, h, h - 96, 26, new Color(0x2E, 0x84, 0x96, 60));
        drawWave(g, w, h, h - 64, 34, new Color(0x1F, 0x66, 0x75, 90));
        drawWave(g, w, h, h - 34, 22, new Color(0x14, 0x50, 0x5E, 120));
    }

    static void drawWave(Graphics2D g, int w, int h, int baseY, int amp, Color c) {
        Path2D.Double p = new Path2D.Double();
        p.moveTo(0, baseY);
        double step = w / 4.0;
        for (int i = 0; i < 4; i++) {
            double x0 = i * step;
            p.quadTo(x0 + step * 0.25, baseY - amp, x0 + step * 0.5, baseY);
            p.quadTo(x0 + step * 0.75, baseY + amp, x0 + step, baseY);
        }
        p.lineTo(w, h); p.lineTo(0, h); p.closePath();
        g.setColor(c);
        g.fill(p);
    }

    static Font font(String family, int style, float size) {
        return new Font(family, style, 10).deriveFont(size);
    }

    /** Draws text with letter spacing (Java has no CSS-like tracking on plain drawString). */
    static void drawTracked(Graphics2D g, String text, Font f, Color c, float tracking, int x, int y) {
        AttributedString as = new AttributedString(text);
        as.addAttribute(TextAttribute.FONT, f);
        as.addAttribute(TextAttribute.FOREGROUND, c);
        as.addAttribute(TextAttribute.TRACKING, tracking);
        g.drawString(as.getIterator(), x, y);
    }

    /** The signature headline: heavy white type with a yellow slab tucked under its first letters. */
    static void headline(Graphics2D g, String text, int x, int baseline, float size, int slabChars) {
        Font f = font("Segoe UI Black", Font.PLAIN, size);
        g.setFont(f);
        FontMetrics fm = g.getFontMetrics();
        int slabW = fm.stringWidth(text.substring(0, Math.min(slabChars, text.length())));
        int slabH = Math.round(size * 0.14f);
        g.setColor(YELLOW);
        g.fillRect(x, baseline - slabH + Math.round(size * 0.06f), slabW, slabH);
        g.setColor(WHITE);
        g.drawString(text, x, baseline);
    }

    static void eyebrow(Graphics2D g, int x, int y) {
        drawTracked(g, "REEL RIVALS", font("Segoe UI", Font.BOLD, 22f), TEAL, 0.34f, x, y);
    }

    /** Word-wrapped paragraph. Returns the y after the last line. */
    static int paragraph(Graphics2D g, String text, Font f, Color c, int x, int y, int maxW, int lineH) {
        g.setFont(f); g.setColor(c);
        FontMetrics fm = g.getFontMetrics();
        StringBuilder line = new StringBuilder();
        for (String word : text.split(" ")) {
            String probe = line.length() == 0 ? word : line + " " + word;
            if (fm.stringWidth(probe) > maxW && line.length() > 0) {
                g.drawString(line.toString(), x, y);
                y += lineH;
                line = new StringBuilder(word);
            } else {
                line = new StringBuilder(probe);
            }
        }
        if (line.length() > 0) { g.drawString(line.toString(), x, y); y += lineH; }
        return y;
    }

    /** A fishing rod: angled shaft, line, and hook. Mirrors the 1.2.1 gallery illustration. */
    static void rod(Graphics2D g, int cx, int cy, int len, Color c, boolean halo, Color haloColor) {
        if (halo) {
            g.setColor(new Color(haloColor.getRed(), haloColor.getGreen(), haloColor.getBlue(), 38));
            int d = Math.round(len * 1.75f);
            g.fillOval(cx - d / 2, cy - d / 2, d, d);
        }
        double dx = len * 0.62, dy = len * 0.72;
        int x0 = (int) (cx - dx / 2), y0 = (int) (cy + dy / 2);
        int x1 = (int) (cx + dx / 2), y1 = (int) (cy - dy / 2);
        g.setStroke(new BasicStroke(9f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        g.setColor(c);
        g.drawLine(x0, y0, x1, y1);
        // line + hook
        g.setStroke(new BasicStroke(2.4f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
        g.setColor(new Color(0xE8F2F4));
        int hookX = x1 + Math.round(len * 0.30f);
        int hookY = y1 + Math.round(len * 0.42f);
        Path2D.Double line = new Path2D.Double();
        line.moveTo(x1, y1);
        line.quadTo(x1 + len * 0.24, y1 + len * 0.10, hookX, hookY);
        g.draw(line);
        g.draw(new Arc2D.Double(hookX - 9, hookY, 18, 18, 200, 250, Arc2D.OPEN));
    }

    static void centered(Graphics2D g, String s, Font f, Color c, int cx, int baseline) {
        g.setFont(f); g.setColor(c);
        g.drawString(s, cx - g.getFontMetrics().stringWidth(s) / 2, baseline);
    }

    static void panel(Graphics2D g, int x, int y, int w, int h, Color stroke) {
        g.setColor(new Color(0x08, 0x22, 0x2B, 120));
        g.fill(new RoundRectangle2D.Float(x, y, w, h, 18, 18));
        g.setStroke(new BasicStroke(2f));
        g.setColor(new Color(stroke.getRed(), stroke.getGreen(), stroke.getBlue(), 110));
        g.draw(new RoundRectangle2D.Float(x, y, w, h, 18, 18));
    }

    // ---- project banner ---------------------------------------------------
    // SPECIES COUNT LIVES HERE. 28 total = 24 custom (one per lure_*.json) + the vanilla
    // four (cod, salmon, tropical, puffer), which are weighed and count toward records.
    // The 1.2.1 banner said 24, counting only the custom ones, which contradicted the store
    // page and undersold the pack. If species are ever added, update SPECIES_COUNT and rerun.
    static final int SPECIES_COUNT = 28;
    static final String MC_VERSIONS = "MINECRAFT 1.21.1 & 26.2";

    static double trackedWidth(Graphics2D g, String text, Font f, float tracking) {
        AttributedString as = new AttributedString(text);
        as.addAttribute(TextAttribute.FONT, f);
        as.addAttribute(TextAttribute.TRACKING, tracking);
        return new TextLayout(as.getIterator(), g.getFontRenderContext()).getAdvance();
    }

    /** Scales a font so the tracked string lands on targetW - keeps the wordmark stable if text changes. */
    static Font fitWidth(Graphics2D g, String text, String family, float targetW, float tracking) {
        Font probe = font(family, Font.PLAIN, 100f);
        double w = trackedWidth(g, text, probe, tracking);
        return font(family, Font.PLAIN, (float) (100f * targetW / w));
    }

    /** Big soft fish shape used as background texture on the banner. */
    static void fishSilhouette(Graphics2D g, int cx, int cy, int len, int alpha, boolean eye) {
        int bodyW = len, bodyH = Math.round(len * 0.52f);
        g.setColor(new Color(0x4F, 0xC6, 0xC0, alpha));
        g.fill(new Ellipse2D.Float(cx - bodyW / 2f, cy - bodyH / 2f, bodyW, bodyH));
        Path2D.Double tail = new Path2D.Double();
        double tx = cx + bodyW * 0.42;
        tail.moveTo(tx, cy);
        tail.lineTo(tx + len * 0.30, cy - len * 0.30);
        tail.lineTo(tx + len * 0.30, cy + len * 0.30);
        tail.closePath();
        g.fill(tail);
        if (eye) {
            int d = Math.round(len * 0.075f);
            g.setColor(new Color(0x06, 0x1C, 0x24, Math.min(255, alpha * 5)));
            g.fillOval(cx - Math.round(bodyW * 0.30f) - d / 2, cy - Math.round(bodyH * 0.16f), d, d);
        }
    }

    static BufferedImage banner() {
        int W = 1920, H = 640;
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newCanvas(img);

        g.setPaint(new GradientPaint(0, H, new Color(0x0B2A34), W, 0, new Color(0x14515C)));
        g.fillRect(0, 0, W, H);
        g.setPaint(new RadialGradientPaint(
                new Point2D.Float(W * 0.72f, H * 0.30f), W * 0.55f,
                new float[]{0f, 1f},
                new Color[]{new Color(0x2A, 0x7D, 0x88, 120), new Color(0x2A, 0x7D, 0x88, 0)}));
        g.fillRect(0, 0, W, H);

        // background fish, right side
        fishSilhouette(g, 1560, 250, 470, 26, true);
        fishSilhouette(g, 1760, 470, 380, 20, true);
        fishSilhouette(g, 1330, 470, 300, 14, false);
        bokeh(g, W, H, 11L);

        // eyebrow
        drawTracked(g, "VANILLA DATA PACK   -   " + MC_VERSIONS,
                font("Segoe UI", Font.BOLD, 30f), TEAL, 0.30f, 112, 140);

        // Wordmark, scaled to a fixed width so copy edits never reflow it. Tracking and size
        // trade off here: for a fixed target width, MORE tracking means a SMALLER font, which
        // is what keeps the caps from swallowing the eyebrow line above.
        String mark = "REEL RIVALS";
        float tracking = 0.18f;
        Font markFont = fitWidth(g, mark, "Segoe UI Black", 1450f, tracking);
        int markBaseline = 352;
        drawTracked(g, mark, markFont, WHITE, tracking, 135, markBaseline);
        // yellow slab tucked just under the first three letters
        double slabW = trackedWidth(g, "REE", markFont, tracking);
        g.setColor(YELLOW);
        g.fillRect(100, markBaseline + 10, (int) slabW, 16);

        g.setFont(font("Segoe UI", Font.PLAIN, 48f));
        g.setColor(WHITE);
        g.drawString("Competitive fishing. Every catch weighed.", 116, 462);

        g.setFont(font("Segoe UI", Font.PLAIN, 44f));
        g.setColor(new Color(0x9FB4BA));
        g.drawString("Chase " + SPECIES_COUNT + " species and battle for the pot in player-run tournaments.", 116, 518);

        g.setFont(font("Segoe UI", Font.BOLD, 34f));
        g.setColor(TEAL);
        g.drawString("by SapperSquad", 118, 584);

        drawWave(g, W, H, H - 70, 30, new Color(0x1F, 0x66, 0x75, 70));
        drawWave(g, W, H, H - 28, 22, new Color(0x14, 0x50, 0x5E, 100));

        g.dispose();
        return img;
    }

    // ---- 1.4.0: bounty board / fish market / angler's log ------------------
    // Colors for the three 1.4.0 systems. Bounty borrows the trophy gold, the market
    // borrows emerald green, the log borrows the almanac's parchment.
    static final Color C_BOUNTY = new Color(0xFFC845);
    static final Color C_MARKET = new Color(0x5CD98A);
    static final Color C_LOG    = new Color(0x8FD4E8);

    /** A faceted emerald, drawn rather than sprited so it scales with the card. */
    static void emerald(Graphics2D g, int cx, int cy, int r, Color c) {
        Path2D.Double p = new Path2D.Double();
        p.moveTo(cx, cy - r);
        p.lineTo(cx + r * 0.72, cy - r * 0.25);
        p.lineTo(cx + r * 0.45, cy + r * 0.85);
        p.lineTo(cx - r * 0.45, cy + r * 0.85);
        p.lineTo(cx - r * 0.72, cy - r * 0.25);
        p.closePath();
        g.setColor(c);
        g.fill(p);
        // top facet highlight
        g.setColor(new Color(255, 255, 255, 70));
        Path2D.Double f = new Path2D.Double();
        f.moveTo(cx, cy - r);
        f.lineTo(cx + r * 0.72, cy - r * 0.25);
        f.lineTo(cx, cy + r * 0.10);
        f.lineTo(cx - r * 0.72, cy - r * 0.25);
        f.closePath();
        g.fill(f);
    }

    /** A small open book / ledger. */
    static void ledger(Graphics2D g, int cx, int cy, int w, Color c) {
        int h = Math.round(w * 0.72f);
        g.setColor(c);
        g.fill(new RoundRectangle2D.Float(cx - w / 2f, cy - h / 2f, w, h, 6, 6));
        g.setColor(new Color(0x0C, 0x2E, 0x38, 200));
        g.fillRect(cx - 2, cy - h / 2 + 4, 4, h - 8);           // spine
        g.setColor(new Color(0x0C, 0x2E, 0x38, 120));
        for (int i = 1; i <= 3; i++) {                            // ruled lines
            int ly = cy - h / 2 + 6 + i * (h - 12) / 4;
            g.fillRect(cx - w / 2 + 8, ly, w / 2 - 14, 3);
            g.fillRect(cx + 6, ly, w / 2 - 14, 3);
        }
    }

    static BufferedImage bounty() {
        int W = 1280, H = 720;
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newCanvas(img);
        galleryBackground(g, W, H);

        eyebrow(g, 72, 76);
        headline(g, "EVERY CATCH PAYS", 72, 168, 62f, 5);

        g.setFont(font("Segoe UI", Font.PLAIN, 27f));
        g.setColor(BODY_GRAY);
        g.drawString("A reason to fish today, and something to show for it.", 74, 214);

        int py = 258, ph = 322, pw = 368, gap = 28;
        int x1 = 72, x2 = x1 + pw + gap, x3 = x2 + pw + gap;

        // --- bounty ---
        panel(g, x1, py, pw, ph, C_BOUNTY);
        star(g, x1 + pw / 2, py + 62, 30, C_BOUNTY);
        centered(g, "THE BOUNTY BOARD", font("Segoe UI", Font.BOLD, 22f), C_BOUNTY, x1 + pw / 2, py + 130);
        paragraph(g, "One target species at a time. Land it to claim 16 emeralds, and it sells "
                + "for double until the bounty rotates.",
                font("Segoe UI", Font.PLAIN, 19f), BODY_GRAY, x1 + 30, py + 168, pw - 60, 28);
        centered(g, "rotates every 7 in-game days", font("Segoe UI", Font.ITALIC, 17f),
                new Color(0x87, 0x9B, 0xA1), x1 + pw / 2, py + ph - 26);

        // --- market ---
        panel(g, x2, py, pw, ph, C_MARKET);
        emerald(g, x2 + pw / 2, py + 58, 30, C_MARKET);
        centered(g, "THE FISH MARKET", font("Segoe UI", Font.BOLD, 22f), C_MARKET, x2 + pw / 2, py + 130);
        paragraph(g, "Sell by exact weight. A 25 kg King Sturgeon is worth 25x a minnow - so "
                + "the big ones are worth keeping.",
                font("Segoe UI", Font.PLAIN, 19f), BODY_GRAY, x2 + 30, py + 168, pw - 60, 28);
        centered(g, "or cash out the whole catch at once", font("Segoe UI", Font.ITALIC, 17f),
                new Color(0x87, 0x9B, 0xA1), x2 + pw / 2, py + ph - 26);

        // --- log ---
        panel(g, x3, py, pw, ph, C_LOG);
        ledger(g, x3 + pw / 2, py + 58, 62, C_LOG);
        centered(g, "THE ANGLER'S LOG", font("Segoe UI", Font.BOLD, 22f), C_LOG, x3 + pw / 2, py + 130);
        paragraph(g, "Your lifetime catches, personal best, tournaments won, bounties claimed "
                + "and emeralds earned.",
                font("Segoe UI", Font.PLAIN, 19f), BODY_GRAY, x3 + 30, py + 168, pw - 60, 28);
        centered(g, "and the rods you have earned", font("Segoe UI", Font.ITALIC, 17f),
                new Color(0x87, 0x9B, 0xA1), x3 + pw / 2, py + ph - 26);

        // command strip
        g.setFont(font("Segoe UI Semibold", Font.PLAIN, 22f));
        g.setColor(TEAL);
        centered(g, "/trigger rr.market      /trigger rr.sellall      /trigger rr.stats",
                font("Segoe UI Semibold", Font.PLAIN, 22f), TEAL, W / 2, 634);

        g.dispose();
        return img;
    }

    /** assets/ counterpart in the flat card style. */
    static BufferedImage cardMarket() {
        int W = 1280, H = 640;
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newCanvas(img);

        g.setPaint(new GradientPaint(0, 0, CARD_TOP, 0, H, CARD_BOTTOM));
        g.fillRect(0, 0, W, H);

        g.setFont(font("Segoe UI", Font.BOLD, 54f));
        g.setColor(CARD_HEAD);
        g.drawString("Every catch pays.", 68, 118);

        paragraph(g, "A rotating bounty fish pays out and sells for double. The market buys "
                + "your catch by exact weight. And the Angler's Log keeps every number "
                + "you have ever earned.",
                font("Segoe UI", Font.PLAIN, 31f), WHITE, 68, 196, 720, 52);

        // One tidy column on the right - scattered placement read as accidental.
        int ix = 1030;
        emerald(g, ix, 168, 56, C_MARKET);
        star(g, ix, 292, 46, C_BOUNTY);
        ledger(g, ix, 412, 98, C_LOG);

        pixelWaves(g, W, H);
        g.dispose();
        return img;
    }

    // ---- card 1: the two-track gear ladder --------------------------------

    static BufferedImage gearLadder() {
        int W = 1280, H = 720;
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newCanvas(img);
        galleryBackground(g, W, H);

        eyebrow(g, 72, 76);
        headline(g, "TWO PATHS TO THE TOP", 72, 168, 64f, 3);

        // shared base strip
        g.setFont(font("Segoe UI Semibold", Font.PLAIN, 21f));
        g.setColor(BODY_GRAY);
        g.drawString("EVERY ANGLER EARNS THE FIRST TWO", 72, 214);
        rod(g, 505, 203, 50, ROD_ANGLER, false, ROD_ANGLER);
        centered(g, "Angler's", font("Segoe UI", Font.BOLD, 17f), BODY_GRAY, 505, 241);
        rod(g, 618, 203, 50, ROD_MASTER, false, ROD_MASTER);
        centered(g, "Master's", font("Segoe UI", Font.BOLD, 17f), BODY_GRAY, 618, 241);
        g.setFont(font("Segoe UI", Font.PLAIN, 29f));
        g.setColor(new Color(0x7FA0A8));
        g.drawString("then the ladder forks", 706, 213);

        // two path panels
        int py = 278, ph = 292, pw = 536;
        panel(g, 72, py, pw, ph, ROD_NATURALIST);
        panel(g, 672, py, pw, ph, ROD_GRANDMASTER);

        drawTracked(g, "NATURALIST PATH", font("Segoe UI", Font.BOLD, 23f), ROD_NATURALIST, 0.16f, 104, py + 46);
        g.setFont(font("Segoe UI", Font.ITALIC, 19f)); g.setColor(new Color(0x8FA8AE));
        g.drawString("earned by exploring", 104, py + 74);

        drawTracked(g, "CIRCUIT PATH", font("Segoe UI", Font.BOLD, 23f), ROD_GRANDMASTER, 0.16f, 704, py + 46);
        g.setFont(font("Segoe UI", Font.ITALIC, 19f)); g.setColor(new Color(0x8FA8AE));
        g.drawString("earned by winning", 704, py + 74);

        pathEntry(g, 175, py + 150, ROD_NATURALIST, "Naturalist's", "a catch in all 9 waters", false);
        pathEntry(g, 445, py + 150, ROD_LEGEND, "Legend", "every species + 15 kg", true);
        pathEntry(g, 775, py + 150, ROD_CHAMPION, "Champion's", "5 played or 1 win", false);
        pathEntry(g, 1045, py + 150, ROD_GRANDMASTER, "Grandmaster's", "5 tournament wins", true);

        // capstone stat line
        g.setFont(font("Segoe UI Semibold", Font.PLAIN, 21f));
        g.setColor(TEAL);
        String stat = "Legend: Luck of the Sea VIII   -   Grandmaster's: Lure IV, fishes twice as fast";
        g.drawString(stat, 72, 610);

        paragraph(g, "Luck pulls rarity, Lure pulls speed - so neither capstone outranks the other. "
                + "Walk both if you can.", font("Segoe UI", Font.PLAIN, 25f), BODY_GRAY, 72, 654, 1140, 34);

        g.dispose();
        return img;
    }

    static void pathEntry(Graphics2D g, int cx, int cy, Color c, String name, String unlock, boolean capstone) {
        rod(g, cx, cy, capstone ? 84 : 70, c, capstone, c);
        if (capstone) star(g, cx + 42, cy - 52, 13, YELLOW);
        centered(g, name, font("Segoe UI", Font.BOLD, capstone ? 23f : 21f), capstone ? c : WHITE, cx, cy + 88);
        centered(g, unlock, font("Segoe UI", Font.PLAIN, 17f), new Color(0x93AAB0), cx, cy + 113);
    }

    static void star(Graphics2D g, int cx, int cy, int r, Color c) {
        Path2D.Double p = new Path2D.Double();
        for (int i = 0; i < 10; i++) {
            double ang = Math.PI / 2 * -1 + i * Math.PI / 5;
            double rad = (i % 2 == 0) ? r : r * 0.45;
            double x = cx + Math.cos(ang) * rad, y = cy + Math.sin(ang) * rad;
            if (i == 0) p.moveTo(x, y); else p.lineTo(x, y);
        }
        p.closePath();
        g.setColor(c);
        g.fill(p);
    }

    // ---- card 2: leaderboard + milestones ---------------------------------

    static BufferedImage endgame() {
        int W = 1280, H = 720;
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newCanvas(img);
        galleryBackground(g, W, H);

        eyebrow(g, 72, 76);
        headline(g, "LEADERBOARDS & LEGENDS", 72, 168, 60f, 4);

        // Top Anglers panel
        int px = 92, py = 248, pw = 470, ph = 300;
        panel(g, px, py, pw, ph, TEAL);
        centered(g, "Top Anglers", font("Segoe UI", Font.BOLD, 30f), TEAL, px + pw / 2, py + 50);
        String[][] rows = {{"1", "ReelDeal", "341"}, {"2", "BassAdmiral", "298"},
                           {"3", "SapperSquad", "276"}, {"4", "GillzMcGee", "210"}, {"5", "NetNinja", "188"}};
        int ry = py + 100;
        for (String[] row : rows) {
            g.setFont(font("Segoe UI", Font.PLAIN, 26f)); g.setColor(new Color(0xC9D6DA));
            g.drawString(row[0], px + 34, ry);
            g.setColor(WHITE);
            g.drawString(row[1], px + 66, ry);
            g.setFont(font("Segoe UI", Font.BOLD, 26f)); g.setColor(YELLOW);
            int wv = g.getFontMetrics().stringWidth(row[2]);
            g.drawString(row[2], px + pw - 40 - wv, ry);
            ry += 44;
        }

        // milestones - 250-catch Legend Rod is gone as of 1.3.0
        int mx = 640, my = 282;
        milestone(g, mx, my,       new Color(0x8B5A2B), "100 catches",   "Bait IV");
        milestone(g, mx, my + 68,  ROD_NATURALIST,      "all 9 waters",  "Naturalist's Rod");
        milestone(g, mx, my + 136, ROD_LEGEND,          "every species", "Legend Rod");
        milestone(g, mx, my + 204, new Color(0x1FA85C), "500 catches",   "King's Feast");
        milestone(g, mx, my + 272, YELLOW,              "1,000 catches", "Master of the Deep");

        paragraph(g, "Post the live Top Anglers board and chase lifetime milestones - your 1,000th catch "
                + "crowns you Master of the Deep, announced server-wide.",
                font("Segoe UI", Font.PLAIN, 25f), BODY_GRAY, 72, 634, 1140, 34);

        g.dispose();
        return img;
    }

    static void milestone(Graphics2D g, int x, int y, Color dot, String top, String label) {
        g.setColor(dot);
        g.fillOval(x, y - 18, 22, 22);
        g.setFont(font("Segoe UI", Font.BOLD, 21f)); g.setColor(TEAL);
        g.drawString(top, x + 42, y - 4);
        g.setFont(font("Segoe UI", Font.BOLD, 27f));
        g.setColor(label.equals("Master of the Deep") ? YELLOW : WHITE);
        g.drawString(label, x + 42, y + 26);
    }

    // ---- card 3: assets/card_progression.png ------------------------------

    static BufferedImage progression() {
        int W = 1280, H = 640;
        BufferedImage img = new BufferedImage(W, H, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newCanvas(img);

        g.setPaint(new GradientPaint(0, 0, CARD_TOP, 0, H, CARD_BOTTOM));
        g.fillRect(0, 0, W, H);

        g.setFont(font("Segoe UI", Font.BOLD, 54f));
        g.setColor(CARD_HEAD);
        g.drawString("Two paths to the top.", 68, 118);

        paragraph(g, "Six rods across two tracks. Fish every water in the world for the "
                + "Naturalist's Rod, or win the circuit for the Grandmaster's. Finish the "
                + "whole ledger to forge the Legend Rod.",
                font("Segoe UI", Font.PLAIN, 31f), WHITE, 68, 196, 700, 52);

        // pixel sprites, right side
        pixelTrophy(g, 940, 128, 9);
        pixelFish(g, 878, 366, 9);

        pixelWaves(g, W, H);
        g.dispose();
        return img;
    }

    static void pixelWaves(Graphics2D g, int w, int h) {
        int px = 16, y = h - 84;
        Color base = new Color(0x2A6489), lite = new Color(0x3E86AE), pop = new Color(0x57A0C6);
        g.setColor(base);
        g.fillRect(0, y + px, w, h - (y + px));
        for (int i = 0; i * px < w; i++) {
            if (i % 2 == 0) { g.setColor(lite); g.fillRect(i * px, y, px, px); }
            if (i % 4 == 1) { g.setColor(pop);  g.fillRect(i * px, y + px, px, px); }
        }
    }

    /** Pixel sprites drawn from string grids: '.' transparent, else a palette key. */
    static void sprite(Graphics2D g, String[] rows, int x, int y, int px, Color[] pal) {
        for (int r = 0; r < rows.length; r++) {
            for (int c = 0; c < rows[r].length(); c++) {
                char ch = rows[r].charAt(c);
                if (ch == '.') continue;
                g.setColor(pal[ch - '1']);
                g.fillRect(x + c * px, y + r * px, px, px);
            }
        }
    }

    static void pixelTrophy(Graphics2D g, int x, int y, int px) {
        String[] s = {
            "1111111111",
            "1222222221",
            "1233333321",
            "1233333321",
            "11333333 1".replace(' ', '3'),
            ".13333331.",
            "..133331..",
            "...1331...",
            "...1331...",
            "..111111..",
            ".11333311.",
            ".11111111.",
        };
        sprite(g, s, x, y, px, new Color[]{ new Color(0x1A1206), new Color(0xFFE07A), new Color(0xE8A317) });
    }

    static void pixelFish(Graphics2D g, int x, int y, int px) {
        // tail fin (4 cols, flares away from the body) + body (13 cols)
        String[] s = {
            "...." + "....11111....",
            "11.." + "..112222211..",
            "121." + ".12222222221.",
            "1222" + "1122222222221",
            "1222" + "1222222223221",
            "1222" + "1122222222221",
            "121." + ".12222222221.",
            "11.." + "..112222211..",
            "...." + "....11111....",
        };
        sprite(g, s, x, y, px, new Color[]{ new Color(0x1A1206), new Color(0xE8A317), new Color(0xFFFFFF) });
    }
}
