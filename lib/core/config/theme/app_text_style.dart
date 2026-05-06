import 'package:flutter/material.dart';

/// Wink App — Text Styles
///
/// Font family used throughout the app: [Lexend]
/// (Confirmed via editor screen: "FONT: LEXEND BOLD")
///
/// Colors are intentionally omitted — apply them from your AppColors file.

class AppTextStyles {
  AppTextStyles._(); // prevent instantiation

  // ---------------------------------------------------------------------------
  // SPLASH / LOADING SCREEN  (Page 1 — Splash screen)
  // ---------------------------------------------------------------------------

  /// "LOADING" — small all-caps tracking label under the progress bar.
  static const TextStyle loading = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.5,
  );

  // ---------------------------------------------------------------------------
  // APP BAR / NAVIGATION BAR  (Home feed, Onboarding, Register, Reset Password)
  // ---------------------------------------------------------------------------

  /// "Wink" — brand name in the top-left app bar on light screens.
  /// Used on: Onboarding page 1, Home feed app bar.
  static const TextStyle appBarBrandName = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// "Join Wink" / "Reset Password" — centered app bar title on dark header.
  /// Used on: Register screen, Reset Password screen.
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  /// "Skip" — ghost action in the top-right of the app bar.
  /// Used on: Onboarding screens.
  static const TextStyle appBarAction = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  /// Bottom nav bar labels — "Home", "Explore", "Inbox", "Profile".
  /// Used on: Home feed, New Post screen.
  static const TextStyle bottomNavLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  /// Bottom nav label (ALL-CAPS variant) — "HOME", "EXPLORE", "ALERTS", "PROFILE".
  /// Used on: Shorts / Vibestream dark screen bottom nav.
  static const TextStyle bottomNavLabelCaps = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  // ---------------------------------------------------------------------------
  // ONBOARDING SCREENS  (Pages 2 – 4)
  // ---------------------------------------------------------------------------

  /// Large onboarding headline — "Share your moments" / "Create Shorts".
  /// Used on: Onboarding slides 1 & 2.
  static const TextStyle onboardingHeadline = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 28,
    fontWeight: FontWeight.w800,
  );

  /// Smaller onboarding headline — "Connect with friends".
  /// Used on: Onboarding slide 3.
  static const TextStyle onboardingHeadlineSecondary = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// Onboarding body / subtitle — supporting paragraph under the headline.
  /// Used on: All three onboarding slides.
  static const TextStyle onboardingBody = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ---------------------------------------------------------------------------
  // AUTHENTICATION SCREENS  (Login, Register, Reset Password)
  // ---------------------------------------------------------------------------

  /// Auth card headline — "Welcome Back" / "Create Account".
  /// Used on: Login screen, Register screen.
  static const TextStyle authHeadline = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  /// Auth sub-headline — "Reset Password" (page-level, not inside card).
  /// Used on: Reset Password screen.
  static const TextStyle authSubHeadline = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// Auth subtitle / description — "Login to your account".
  /// Used on: Login screen, Register screen, Reset Password screen.
  static const TextStyle authSubtitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Input field label (ALL-CAPS) — "EMAIL ADDRESS", "PASSWORD".
  /// Used on: Login, Register, Reset Password screens.
  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
  );

  /// Input field label (mixed-case) — "Username", "Email".
  /// Used on: Register screen alongside ALL-CAPS labels.
  static const TextStyle inputLabelMixed = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// Input field placeholder / hint — "hello@winkapp.com", "ahmed_ali".
  /// Used on: All text fields across auth screens.
  static const TextStyle inputHint = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  /// Input field active / filled text.
  /// Used on: All text fields when the user is typing.
  static const TextStyle inputText = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  /// Primary CTA button label — "Log In", "Sign Up", "Next", "Get Started".
  /// Used on: Yellow pill buttons across auth and onboarding screens.
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Secondary / outline button label — "Back".
  /// Used on: Outline pill buttons on onboarding and auth screens.
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Social auth button label — "Continue with Google".
  /// Used on: Login screen Google button.
  static const TextStyle buttonSocial = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Inline link span — "Sign Up", "Log In" highlighted within a sentence.
  /// Used on: "Don't have an account? Sign Up", "Already have an account? Log In".
  static const TextStyle inlineLink = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Standalone text link — "Forgot Password?", "Back to Log In".
  /// Used on: Login screen, Reset Password screen.
  static const TextStyle textLink = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Legal disclaimer text — "By signing up, you agree to our ...".
  /// Used on: Register screen footer.
  static const TextStyle legalText = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Legal inline link span — "Terms" and "Privacy Policy".
  /// Used on: Register screen legal text (inline span).
  static const TextStyle legalLink = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );

  /// General body / paragraph text.
  /// Used on: Reset Password description, any supporting body copy.
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  // ---------------------------------------------------------------------------
  // HOME FEED  (Feed screen)
  // ---------------------------------------------------------------------------

  /// Story label beneath avatar circles — "Your Story", "alex_vibe".
  /// Used on: Home feed story row.
  static const TextStyle storyLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  /// Post username — "sarah.creative", "explore_with_dan".
  /// Used on: Feed post card header.
  static const TextStyle postUsername = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Post metadata — "2 hours ago • Brooklyn, NY".
  /// Used on: Feed post card header sub-line.
  static const TextStyle postMeta = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Post caption / body text — post description and hashtags.
  /// Used on: Feed post caption.
  static const TextStyle postCaption = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Post engagement count — "1.2k", "84", "3.8k".
  /// Used on: Feed post action bar (likes, comments, shares).
  static const TextStyle postEngagementCount = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// "View all 84 comments" link.
  /// Used on: Feed post below caption.
  static const TextStyle viewAllComments = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // ---------------------------------------------------------------------------
  // STORY VIEWER  (Full-screen story overlay)
  // ---------------------------------------------------------------------------

  /// Story viewer username — "maya.explores".
  /// Used on: Full-screen story overlay header.
  static const TextStyle storyViewerUsername = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// Story viewer timestamp — "2h ago".
  /// Used on: Full-screen story overlay header sub-line.
  static const TextStyle storyViewerTimestamp = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Story reply input placeholder — "Send message...".
  /// Used on: Story viewer bottom reply bar.
  static const TextStyle storyReplyHint = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // ---------------------------------------------------------------------------
  // CREATE BOTTOM SHEET  (Create content modal)
  // ---------------------------------------------------------------------------

  /// Bottom sheet title — "Create".
  /// Used on: Create content bottom sheet header.
  static const TextStyle bottomSheetTitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// Create option primary label — "Post", "Story", "Shorts".
  /// Used on: Create bottom sheet list items.
  static const TextStyle createOptionTitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Create option subtitle — "Select Photo from gallery", "Record Shorts video".
  /// Used on: Create bottom sheet list items (description line).
  static const TextStyle createOptionSubtitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  /// Section header label (ALL-CAPS) — "RECENT ASSETS".
  /// Used on: Create bottom sheet asset picker section heading.
  static const TextStyle sectionHeaderCaps = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.4,
  );

  /// "VIEW ALL" — small action link beside section headers.
  /// Used on: Create bottom sheet "RECENT ASSETS" row.
  static const TextStyle viewAllLink = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  // ---------------------------------------------------------------------------
  // NEW POST SCREEN
  // ---------------------------------------------------------------------------

  /// Screen title — "New Post".
  /// Used on: New Post screen app bar.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  /// Caption input placeholder — "Write a caption...".
  /// Used on: New Post caption field.
  static const TextStyle captionHint = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  /// Row option label — "Tag People", "Add Location".
  /// Used on: New Post options list.
  static const TextStyle postOptionLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// Toggle row primary label — "Share to Story".
  /// Used on: New Post "Share to Story" toggle.
  static const TextStyle toggleLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// Toggle row description — "Automatically post this to your story".
  /// Used on: New Post "Share to Story" toggle description.
  static const TextStyle toggleDescription = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Feature chip label — "Reach +20%", "Enhance".
  /// Used on: New Post feature chips.
  static const TextStyle chipLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // ---------------------------------------------------------------------------
  // SHORTS / VIDEO SCREEN  (Shorts feed, Vibestream)
  // ---------------------------------------------------------------------------

  /// Shorts screen brand tag — "VIBESTREAM" (ALL-CAPS bold).
  /// Used on: Vibestream shorts screen top-left.
  static const TextStyle shortsBrand = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
  );

  /// Shorts username overlay — "@the_vibe_curator".
  /// Used on: Shorts video overlay, bottom-left username.
  static const TextStyle shortsUsername = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Shorts caption / description overlay.
  /// Used on: Shorts video overlay caption text.
  static const TextStyle shortsCaption = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Shorts engagement count — "24.8K", "842", "4.2K".
  /// Used on: Shorts right-side action bar counts.
  static const TextStyle shortsEngagementCount = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // ---------------------------------------------------------------------------
  // TEXT EDITOR / STICKER OVERLAY  (Story & Shorts editor)
  // ---------------------------------------------------------------------------

  /// Text overlay on media — e.g. "GOLDEN HOUR" pill label.
  /// Font confirmed as Lexend Bold via the in-app font picker.
  /// Used on: Story / Shorts text editor overlay.
  static const TextStyle mediaTextOverlay = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 64, // default size shown in design (64px slider position)
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
  );

  /// Editor font picker label — "LEXEND BOLD".
  /// Used on: Text editor toolbar font selector.
  static const TextStyle editorFontPickerLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  /// "Done" button label in editor.
  /// Used on: Story / Shorts text editor toolbar.
  static const TextStyle editorDoneButton = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  /// Editor hint — "DRAG TO REPOSITION • PINCH TO SCALE".
  /// Used on: Text editor overlay bottom hint.
  static const TextStyle editorHint = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
  );

  // ---------------------------------------------------------------------------
  // PROFILE
  // ---------------------------------------------------------------------------

  /// Profile photo upload label — "Upload Profile Photo".
  /// Used on: Register screen avatar picker.
  static const TextStyle profileUploadLabel = TextStyle(
    fontFamily: 'Lexend',
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
}