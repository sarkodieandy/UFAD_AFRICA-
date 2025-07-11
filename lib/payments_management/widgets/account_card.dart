import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ufad/payments_management/model/account.dart';

class AccountCard extends StatefulWidget {
  final Account account;
  final bool isPrimary;

  const AccountCard({super.key, required this.account, this.isPrimary = false});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _balanceAnim;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650))..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutExpo);
    _slide = Tween<Offset>(begin: const Offset(0.07, 0.10), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _balanceAnim = Tween<double>(begin: 0, end: widget.account.balance).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutExpo),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isPrimary
                    ? [const Color(0xFF16A085), const Color(0xFF2DD4BF)]
                    : [const Color(0xFF1e3a8a), const Color(0xFF3b82f6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: (widget.isPrimary ? Colors.teal : Colors.blue).withOpacity(_hover ? 0.25 : 0.13),
                  blurRadius: _hover ? 30 : 24,
                  spreadRadius: 4,
                  offset: const Offset(2, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: 0,
                  child: Container(
                    width: 72,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.23), Colors.transparent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.amber[200],
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        if (widget.isPrimary)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.star, color: Colors.white, size: 22),
                          ),
                        Text(
                          widget.isPrimary ? "Primary Account" : "Account",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      acc.name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.1,
                      ),
                    ),
                    Text(
                      acc.type.replaceAll('_', ' ').toUpperCase(),
                      style: GoogleFonts.robotoMono(
                        color: Colors.white70,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    AnimatedBuilder(
                      animation: _balanceAnim,
                      builder: (_, __) => Text(
                        "GHS ${_balanceAnim.value.toStringAsFixed(2)}",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.white.withOpacity(0.83),
                        size: 38,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.13),
                            blurRadius: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
