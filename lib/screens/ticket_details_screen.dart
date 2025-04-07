import 'package:flutter/material.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/services/ticket_service.dart';

class TicketDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailsScreen({
    Key? key,
    required this.ticketData,
  }) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isCommentVisible = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];
  late TabController _tabController;
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // If we only have a ticket ID, fetch the full ticket data
    if (widget.ticketData.containsKey('id') && widget.ticketData.length < 5) {
      _fetchTicketDetails(widget.ticketData['id']);
    }
  }

  Future<void> _fetchTicketDetails(String ticketId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ticket = await TicketService.getTicketById(ticketId);
      if (ticket != null) {
        setState(() {
          // Update the ticket data with the fetched details
          widget.ticketData.addAll(ticket.toJson());
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading ticket: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleCommentField() {
    setState(() {
      _isCommentVisible = !_isCommentVisible;
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
        _isCommentVisible = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.white,
                expandedHeight: 320,
                pinned: true,
                floating: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: innerBoxIsScrolled
                    ? Text(
                        widget.ticketData['subject'] ?? 'Ticket Details',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
                    color: AppColors.cardBackground,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.ticketData['subject'] ??
                                'No subject provided',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.cardBackground,
                      border: Border(
                        bottom:
                            BorderSide(color: AppColors.lightGrey, width: 1),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryBlue,
                      indicatorWeight: 3,
                      labelColor: AppColors.primaryBlue,
                      unselectedLabelColor: AppColors.grey,
                      tabs: const [
                        Tab(text: 'PROGRESS'),
                        Tab(text: 'COMMENTS'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // PROGRESS Tab
              Container(
                color: AppColors.cardBackground,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProgressItem('New ticket', true),
                      _buildProgressItem('Acknowledged by Support',
                          widget.ticketData['status'] != 'New'),
                      _buildProgressItem(
                          'Assigned to Technician',
                          widget.ticketData['status'] == 'In Progress' ||
                              widget.ticketData['status'] == 'Completed'),
                      _buildProgressItem(
                          'In Progress',
                          widget.ticketData['status'] == 'In Progress' ||
                              widget.ticketData['status'] == 'Completed'),
                      _buildProgressItem(
                          'Solved', widget.ticketData['status'] == 'Completed',
                          isLast: true),
                    ],
                  ),
                ),
              ),

              // COMMENTS Tab
              Container(
                color: AppColors.cardBackground,
                child: _isCommentVisible
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _commentController,
                              maxLines: 3,
                              style: const TextStyle(color: AppColors.white),
                              decoration: InputDecoration(
                                hintText: 'Add your comment here...',
                                hintStyle:
                                    const TextStyle(color: AppColors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.lightGrey),
                                ),
                                filled: true,
                                fillColor: AppColors.cardBackground,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCommentVisible = false;
                                      _commentController.clear();
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.white,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _addComment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlue,
                                    foregroundColor: AppColors.white,
                                  ),
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _comments.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // System comment
                            return _buildCommentCard(
                              'Support Team',
                              'Your ticket has been received. Our team will review it shortly.',
                              isSupport: true,
                            );
                          }
                          final comment = _comments[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _buildCommentCard('You', comment),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedTabIndex == 1
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryBlue,
              onPressed: _toggleCommentField,
              child: const Icon(Icons.add_comment, color: AppColors.white),
              elevation: 4,
            )
          : null,
    );
  }

  Widget _buildInfoCard() {
    // Format date to be more readable
    String formattedDate = widget.ticketData['date'] ?? '';
    try {
      if (formattedDate.contains('T')) {
        final dateTime = DateTime.parse(formattedDate);
        formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      // Use original date if parsing fails
    }

    return Card(
      color: AppColors.cardBackground.withOpacity(0.7),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            BorderSide(color: AppColors.primaryBlue.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket #${widget.ticketData['id'] ?? ''}',
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusBadge(widget.ticketData['status'] ?? 'New'),
              ],
            ),
            const Divider(color: AppColors.lightGrey, height: 24),
            _buildInfoRow('Assigned to', 'Support Team'),
            _buildInfoRow(
                'Category', widget.ticketData['category'] ?? 'General Support'),
            if (widget.ticketData['technicalSupportType'] != null)
              _buildInfoRow(
                  'Support Type', widget.ticketData['technicalSupportType']),
            _buildInfoRow(
                'Priority', widget.ticketData['priority'] ?? 'Medium'),
            _buildInfoRow('Date', formattedDate),
            const Divider(color: AppColors.lightGrey, height: 24),
            const Text(
              'Description',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.ticketData['description'] ?? 'No description provided',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if ((widget.ticketData['description'] ?? '').length > 100)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Show full description in a dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.cardBackground,
                        title: const Text(
                          'Full Description',
                          style: TextStyle(color: AppColors.white),
                        ),
                        content: SingleChildScrollView(
                          child: Text(
                            widget.ticketData['description'] ?? '',
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Read More',
                    style: TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
              ),
            // Show attachment if available
            if (widget.ticketData['attachment_url'] != null &&
                widget.ticketData['attachment_url'].toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.lightGrey),
                  const SizedBox(height: 8),
                  const Text(
                    'Attachment',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      // Open attachment (would need to implement a viewer)
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primaryBlue.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_file,
                              color: AppColors.primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'View Attachment',
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label + ':',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(String author, String content,
      {bool isSupport = false}) {
    return Card(
      color: isSupport
          ? AppColors.primaryBlue.withOpacity(0.1)
          : AppColors.cardBackground,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSupport
              ? AppColors.primaryBlue.withOpacity(0.3)
              : AppColors.lightGrey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isSupport ? AppColors.primaryBlue : AppColors.white,
                  child: Icon(
                    isSupport ? Icons.support_agent : Icons.person,
                    color:
                        isSupport ? AppColors.white : AppColors.cardBackground,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  author,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSupport ? AppColors.primaryBlue : AppColors.white,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  'Just now',
                  style: TextStyle(
                    color: AppColors.grey.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    if (status.toLowerCase() == 'in progress') {
      statusColor = Colors.blue;
    } else if (status.toLowerCase() == 'pending') {
      statusColor = Colors.orange;
    } else if (status.toLowerCase() == 'completed') {
      statusColor = Colors.green;
    } else if (status.toLowerCase() == 'new') {
      statusColor = Colors.purple;
    } else {
      statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildProgressItem(String text, bool isCompleted,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primaryBlue : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.primaryBlue : AppColors.grey,
                  width: 2,
                ),
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.access_time,
                color: isCompleted ? AppColors.white : AppColors.grey,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted
                    ? AppColors.primaryBlue
                    : AppColors.grey.withOpacity(0.5),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isCompleted ? AppColors.white : AppColors.grey,
                  fontSize: 16,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isLast
                        ? 'Completed on ${widget.ticketData['date'] ?? 'today'}'
                        : 'Updated on ${widget.ticketData['date'] ?? 'today'}',
                    style: TextStyle(
                      color: AppColors.grey.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ),
              SizedBox(height: isLast ? 0 : 20),
            ],
          ),
        ),
      ],
    );
  }
}
